# 静态站点发布说明（面向 AI 代理）

本站点是纯静态托管：你把文件上传上去，服务器原样对外提供。**没有 PHP / CGI /
Node / `_worker.js`，没有 `.htaccess`，没有服务端路由**，`index.html` 之外的逻辑
一律由浏览器执行。站点根路径就是归档包的根目录。

- 站点地址：`https://@DOMAIN@/`
- 接口基址：`https://@DOMAIN@/__publish`
- 鉴权：`Authorization: Bearer <TOKEN>`（TOKEN 由站点管理员提供，等价写法
  `X-Auth-Token: <TOKEN>`）
- 接口不限速，但发布是串行的（同一时刻只有一次发布在生效）。

先用 `GET /healthz` 确认服务在线（无需鉴权）：

```bash
curl -fsS https://@DOMAIN@/__publish/healthz
# {"ok": true, "current": "20261027T103000Z-init-1a2b", "releases": 1}
```

## 1. 发布整站（推荐，原子生效）

在 `index.html` 所在的目录里打包，然后一次上传：

```bash
cd /path/to/site-with-index-html
tar czf /tmp/site.tar.gz .

curl -fsS -X POST \
  -H "Authorization: Bearer $TOKEN" \
  --data-binary @/tmp/site.tar.gz \
  "https://@DOMAIN@/__publish/publish?name=init"
```

成功返回：

```json
{
  "ok": true,
  "release": "20261027T103000Z-init-1a2b",
  "files": 23,
  "bytes": 1843200,
  "uploadBytes": 512345,
  "strippedTopDir": null,
  "url": "https://@DOMAIN@/"
}
```

要点：

- 站点较大时用 `curl -T` 流式上传（不把整包读进客户端内存，等价于同一个接口）：

  ```bash
  curl -fsS -T /tmp/site.tar.gz \
    -H "Authorization: Bearer $TOKEN" \
    "https://@DOMAIN@/__publish/publish?name=init"
  ```

- **必须是 tar（gzip/bzip2/xz/未压缩都可以）**，不支持 zip。若是 zip，先解开再 tar。
- **根目录必须有 `index.html`**（或 `index.htm`）。少了会被拒绝，返回 400 并列出
  归档里的前几个路径。
- 若打包时多套了一层目录（`tar czf s.tar.gz site/` → 里面是 `site/index.html`），
  服务端会自动剥掉这一层，响应里 `strippedTopDir` 会显示被剥掉的目录名。
- 上传 → 校验 → 解包到新版本目录 → 原子切换 `current` 软链接。**上传失败或校验
  失败不会影响线上已发布的内容**，所以可以放心重试。
- `?name=` 可选，只用来给版本起个便于人读的后缀（`init`、`add-team-page` 等）。

## 2. 只改一个文件（快速修复）

不用整站重传，直接写进当前生效的版本：

```bash
curl -fsS -X POST \
  -H "Authorization: Bearer $TOKEN" \
  --data-binary @assets/style.css \
  "https://@DOMAIN@/__publish/file?path=assets/style.css"
```

`path` 是相对站点根的路径，子目录会自动创建。适合改 CSS / 单个 html / 换张图。

## 3. 查看版本与回滚

```bash
# 列出所有保留的版本（新的在前），current 字段是当前生效版本
curl -fsS -H "Authorization: Bearer $TOKEN" \
  "https://@DOMAIN@/__publish/releases"

# 回滚到任一历史版本
curl -fsS -X POST -H "Authorization: Bearer $TOKEN" \
  -d '{"release":"20261027T103000Z-init-1a2b"}' \
  "https://@DOMAIN@/__publish/rollback"
```

服务端保留最近 8 个版本（当前生效的那个永远不会被清理），所以改坏了可以立刻切回。

## 4. 硬限制

| 限制 | 值 |
| --- | --- |
| 单次上传体积 | ≤ 200 MB |
| 解包后总体积 | ≤ 400 MB |
| 条目数 | ≤ 5000 |
| 归档内容 | 只允许普通文件和目录 |

- **符号链接、硬链接、设备文件一律拒绝**（返回 400）。
- 只托管静态资源：HTML / CSS / JS / 图片 / 字体 / JSON / PDF 等。**上传的脚本不会
  在服务器上执行**；需要动态能力就让页面调用外部 API。
- 站点按域名根路径提供，`/assets/style.css`、`./assets/style.css`、`assets/style.css`
  都能用；不要写死 `file://` 或本地绝对路径。
- 目录列表是关闭的，每个页面都要有真实文件。

## 5. 出错时看什么

| 状态码 | 含义 / 处理 |
| --- | --- |
| 401 | token 错或没带 `Authorization` 头 |
| 400 | 包不是 tar / 根目录缺 `index.html` / 含符号链接 |
| 411 | 没带 `Content-Length`（用 `--data-binary @文件`，不要用管道） |
| 413 | 超过体积或条目数上限 |
| 404 | 路径写错，接口清单见本文档 |
| 409 | `/file` 单文件更新时线上还没有任何版本，先做一次整站发布 |
| 500 | 服务端异常，响应里带原因；稍后重试，失败不影响线上内容 |

## 6. 非 curl 写法（Python）

```python
import requests

TOKEN = "..."
base = "https://@DOMAIN@/__publish"
with open("/tmp/site.tar.gz", "rb") as fh:
    r = requests.post(
        f"{base}/publish",
        params={"name": "init"},
        headers={"Authorization": f"Bearer {TOKEN}"},
        data=fh,
        timeout=180,
    )
print(r.status_code, r.json())
```
