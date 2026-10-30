# rhcg-site —— 静态站发布 / 上传口（tar + token）

给一个静态站用的最小发布系统（当前部署在 `aliyun-vm-sh`）。设计目标只有一个：
**让一个 AI 代理用两条 `curl` 命令把生成的整站传上去，且它没有任何办法弄坏这台机器。**

> **对外域名不在本仓库。** 本模块不存储、不打印任何域名：`/docs` 和响应里的 URL 全部按请求的
> `Host` 头现算，唯一知道真实域名的是私密仓库的反向代理配置（§“启用” 第 2 条）。

## 架构

```
        AI / 导师
           │  POST tar.gz + Bearer token
           ▼
   caddy :443  <public-host>
     ├── /__publish/*  → 127.0.0.1:18778  (rhcg-site-publish, 本模块)
     └── /*            → file_server /data/www/rhcg/current
                                              │ 软链
                                              ▼
                                     releases/<UTC时间>-<label>-<rand>/
```

- 上传 → 校验 → 解包到**新版本目录** → 原子切换 `current` 软链。失败不影响线上。
- 保留最近 8 个版本（当前生效的永不清理），`/rollback` 可秒回。
- 服务以系统用户 `rhcg` 运行，`ProtectSystem=strict` + 只可写 `/data/www/rhcg`；
  没开 ssh，没有 shell，密钥只在 `/data/www/rhcg/state/token`（0600）。

## 启用

1. `modules/options.nix`、`outputs/config-presets/bare.nix` 已声明开关；
   `outputs/x86_64-linux/hosts/aliyun-vm-sh.nix` 里已开：

   ```nix
   rhcg-site.enable = true;      # 只有 enable（和可选 port），主机名不在这里
   ```

2. caddy 的站点块在**私密仓库** `nixos-secrets/caddy/caddyfile-aliyun-vm-sh` 末尾
   （`build` 里没有 caddy 的通用配置机制，hostname 属于"部署拓扑"，放私密仓库）。
   改了私密仓库 = commit **且 push** → `just upp mysecrets` → 才能构建。
3. 新增文件必须 `git add` 才会被 flake 看见（`git+file://` 只认索引里的文件）。

## 部署

```bash
# 1. 私密仓库（caddyfile）
cd nixos-secrets && git add caddy/caddyfile-aliyun-vm-sh && git commit -m "feat(caddy): add site block for the static publisher" && git push
cd .. && just upp mysecrets

# 2. 本仓库（新文件先入索引）
git add modules/nixos/server/rhcg-site modules/nixos/server/rhcg-site.nix \
        modules/options.nix outputs/config-presets/bare.nix \
        outputs/x86_64-linux/hosts/aliyun-vm-sh.nix modules/nixos/server/README.md

# 3. 验证再部署（just preview 是给本机 rog-ga502 的，verify 这台要指名 host）
nix fmt
nix build --dry-run --no-link "path:$PWD#nixosConfigurations.aliyun-vm-sh.config.system.build.toplevel"
colmena apply --on '@vm-sh' --verbose        # 或 just col vm-sh
```

## 首次初始化

服务启动时没有 token 就自己生成，并铺一个"尚未部署"占位页。取 token：

```bash
ssh aliyun-vm-sh sudo rhcg-site
# == token      <43 字符>
# == releases / current / size
```

把这两样交给导师（他自己转交给他的 AI）：

- 说明书：`https://<public-host>/__publish/docs`（无需鉴权，Markdown，专给 AI 读；
  返回内容里的域名是拿请求的 `Host` 现填的，仓库里不存）
- token：`Authorization: Bearer <token>`

## 运维

| 操作 | 做法 |
| --- | --- |
| 换 token | `sudo rm /data/www/rhcg/state/token && sudo systemctl restart rhcg-site-publish`（新 token 在日志/`rhcg-site` 里） |
| 不用默认 token | 在私密仓库加 `age.secrets.rhcg-publish-token`（`secrets/modules/` 里声明），模块会自动改用它 |
| 看谁传了什么 | `journalctl -u rhcg-site-publish -f`（每次发布记录版本名、文件数、体积） |
| 回滚 | `POST /__publish/rollback {"release":"..."}`，或把 `current` 软链指回去 |
| 清历史 | 自动保留 8 个；手动 `rm -rf /data/www/rhcg/releases/<x>` |
| 关掉整个功能 | host 文件里 `rhcg-site.enable = false;`（caddy 块要另删，否则 502） |

## 取舍（为什么不选别的）

| 方案 | 结论 |
| --- | --- |
| **HTTP + tar + token（本方案）** | 对 AI 最友好：一条命令、无 ssh 密钥交换、无客户端依赖；原子发布；代价是一个 ~450 行的自维护服务 |
| ssh + rsync（受限用户） | 服务器端零代码，但要跟导师换公钥，且 `rsync` 的 `--delete` 一失误就清空目录 |
| git push + post-receive | 有历史可查、原子性好；但要求对方会用 git 且配 SSH key，比 curl 多一层门槛 |
| caddy webdav 插件 | 要重算 `withPlugins` hash，整站上传变成几十个请求，且非原子 |
| Cloudflare Pages / R2 | 省服务器，但脱离自己的机器、要域名 CNAME 改向，不符合"用现有 VPS"的前提 |

安全边界：token 泄露的最坏结果是往一个独立子域塞垃圾静态页（不会执行、不能读别的服务、
不能写别的目录），封堵手段是删 token 重启，30 秒的事。

## 已知限制

- 只托管静态文件。要评论/表单/搜索，得让页面调外部 API 或另开服务。
- 没有目录列表、没有按目录的访问控制（要密码就再套 caddy `basic_auth`，或在 authentik 里加一条）。
- 大陆访问合规取决于域名备案状态，与本模块无关。
