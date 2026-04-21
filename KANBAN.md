# 📋 Kanban Board — Richie Server (Homelab)

> Metodologia Kanban aplicada ao projeto. Cada card possui documentação detalhada em `kanban/cards/`.

## WIP Limits

| Coluna      | Limite |
|-------------|--------|
| Backlog     | ∞      |
| To Do       | ∞      |
| In Progress | 1      |
| Review      | 3      |
| Done        | ∞      |

---

## Backlog

- [KB-015](kanban/cards/KB-015.md) — Transmission (cliente torrent)
- [KB-016](kanban/cards/KB-016.md) — Prowlarr (gerenciador de indexadores)
- [KB-017](kanban/cards/KB-017.md) — Radarr (gerenciador de filmes)
- [KB-018](kanban/cards/KB-018.md) — Sonarr (gerenciador de séries)
- [KB-019](kanban/cards/KB-019.md) — LazyLibrarian (gerenciador de ebooks)
- [KB-020](kanban/cards/KB-020.md) — Calibre (servidor de ebooks)
- [KB-021](kanban/cards/KB-021.md) — Filebrowser (gerenciador de arquivos web)

---

## To Do

- [KB-022](kanban/cards/KB-022.md) — Joplin Server (sincronização de notas)

---

## In Progress (max: 1)

- [KB-014](kanban/cards/KB-014.md) — Volume compartilhado de mídia

---

## Review (max: 3)

_Sem itens no momento._

---

## Done

- [KB-001](kanban/cards/KB-001.md) — Estrutura do Repositório
- [KB-002](kanban/cards/KB-002.md) — Ansible Playbook: Configuração do OS e K3s
- [KB-003](kanban/cards/KB-003.md) — Bootstrap do ArgoCD
- [KB-004](kanban/cards/KB-004.md) — ArgoCD App of Apps
- [KB-005](kanban/cards/KB-005.md) — Makefile: Ponto de Entrada `make install`
- [KB-006](kanban/cards/KB-006.md) — Ingress com Traefik
- [KB-007](kanban/cards/KB-007.md) — cert-manager + Cloudflare DNS-01
- [KB-008](kanban/cards/KB-008.md) — Sealed Secrets
- [KB-009](kanban/cards/KB-009.md) — Primeira Aplicação: Glance (Homepage)
- [KB-010](kanban/cards/KB-010.md) — PostgreSQL + pgAdmin
- [KB-012](kanban/cards/KB-012.md) — Quebrar dependência cíclica ArgoCD ↔ Sealed Secrets
- [KB-013](kanban/cards/KB-013.md) — Corrigir versão do chart PostgreSQL Bitnami
- [KB-011](kanban/cards/KB-011.md) — Primeiro Setup

---

## Como usar

- Cada item segue o formato: `- [KB-XXX](kanban/cards/KB-XXX.md) — Título breve`
- Detalhes completos de cada card estão em `kanban/cards/KB-XXX.md`
- Respeitar os limites de WIP antes de mover itens para uma coluna
- Ao mover um card, atualizar tanto este board quanto o histórico no arquivo do card
