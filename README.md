# 🏠 Richie Server

Homelab pessoal rodando K3s + ArgoCD (GitOps).

## Stack
- **K3s** — Kubernetes leve
- **ArgoCD** — GitOps
- **Traefik** — Ingress / Reverse proxy
- **cert-manager** — TLS automático via Let's Encrypt
- **Prometheus + Grafana** — Monitoramento
- **Loki** — Logging centralizado
- **Sealed Secrets** — Gestão de secrets

## Aplicações
| App | Namespace | URL |
|-----|-----------|-----|
| ArgoCD | argocd | argocd.cusin-server.duckdns.org |
| Grafana | monitoring | grafana.cusin-server.duckdns.org |
| Home Assistant | home | homeassistant.cusin-server.duckdns.org |
| qBittorrent | downloads | qbittorrent.cusin-server.duckdns.org |
| Kavita | media | kavita.cusin-server.duckdns.org |
| Audiobookshelf | media | audiobookshelf.cusin-server.duckdns.org |
| Calibre | media | calibre.cusin-server.duckdns.org |
| Radarr | downloads | radarr.cusin-server.duckdns.org |
| Sonarr | downloads | sonarr.cusin-server.duckdns.org |
| Readarr | downloads | readarr.cusin-server.duckdns.org |
| Prowlarr | downloads | prowlarr.cusin-server.duckdns.org |
| Nextcloud | cloud | nextcloud.cusin-server.duckdns.org |
| Filebrowser | cloud | files.cusin-server.duckdns.org |
| Joplin | cloud | joplin.cusin-server.duckdns.org |
| Glance | tools | glance.cusin-server.duckdns.org |
| Draw.io | tools | drawio.cusin-server.duckdns.org |

## Trocar IP / Domínio
1. Atualizar `config.yaml` na raiz do repositório
2. Atualizar o IP no painel do DuckDNS
3. ArgoCD aplica automaticamente
