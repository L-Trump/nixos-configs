# Server modules

The modules in this directory are used in my cloud servers

## Default port mappings

| Service            | Listening Address       | Note                     |
| ------------------ | ----------------------- | ------------------------ |
| easytier           | [::]:(11010-11012)      | SDWan tool               |
| caddy              | [::]:(80/443/8080/8443) | Proxy Server             |
| duplicati          | localhost:8200          | Backup tool              |
| homepage-dashboard | localhost:8255          | Dashboard                |
| redis-juicefs-meta | et-ip:6379              | JuiceFS Meta database    |
| juicefs-s3-gateway | et-ip/localhost:8260    | JuiceFS S3 Gateway       |
| juicefs-webdav     | et-ip/localhost:8261    | JuiceFS Webdav Gateway   |
| minio              | localhost:(9096/9097)   | MinIO and its console    |
| rustdesk-server    | [::]:(21115-21119)      | rustdesk server          |
| rustdesk-api       | [::]:(21114)            | rustdesk api server      |
| vaultwarden        | localhost:8222          | secrests manager         |
| nezha-server       | et-ip:8008              | nezha dashboard          |
| kopia              | localhost:51515         | Kopia backup service     |
| backrest           | localhost:9898          | Backrest backup service  |
| syncthing          | localhost:8384          | Syncthing service        |
| openlist           | localhost:(5244/5246)   | openlist server          |
| hubproxy           | localhost:5000          | hubproxy server          |
| immich (ml)        | et-ip:3003              | Immich machine learning  |
| siyuan-server      | et-ip:6806              | Siyuan docker            |
| ncm-api            | et-ip:6816              | NeteaseCloudMusic API    |
| cloudreve-master   | et-ip:5212              | Cloudreve master node    |
| xpipe-webtop       | et-ip:6790              | xpipe webtop             |
| authentik          | localhost:(6900-6940)   | authentik server         |
| sshwifty           | localhost:8182          | sshwifty server          |

**Note:** et-ip means the virtual ipv4 address in easytier, indicating the service can only be accessed in the internal network.
