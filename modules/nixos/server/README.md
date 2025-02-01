# Server modules

The modules in this directory are used in my cloud servers

## Default port mappings

| Service            | Listening Address       | Note                  |
| ------------------ | ----------------------- | --------------------- |
| easytier           | [::]:(11010-11012)      | SDWan tool            |
| caddy              | [::]:(80/443/8080/8443) | Proxy Server          |
| duplicati          | localhost:8200          | Backup tool           |
| homepage-dashboard | localhost:8255          | Dashboard             |
| redis-juicefs-meta | et-ip:6379              | JuiceFS Meta database |
| minio              | localhost:(9096/9097)   | MinIO and its console |
| rustdesk-server    | [::]:(21114-21118)      | rustdesk server       |
| vaultwarden        | localhost:8222          | secrests manager      |
| nezha-server       | et-ip:8008              | nezha dashboard       |
| kopia              | localhost:51515         | Kopia backup service  |

**Note:** et-ip means the virtual ipv4 address in easytier, indicating the service can only be accessed in the internal network.
