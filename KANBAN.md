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

_Vazio_

---

## To Do

- [KB-002](kanban/cards/KB-002.md) — Ansible Playbook: Configuração do OS e K3s
- [KB-003](kanban/cards/KB-003.md) — Bootstrap do ArgoCD
- [KB-004](kanban/cards/KB-004.md) — ArgoCD App of Apps
- [KB-005](kanban/cards/KB-005.md) — Makefile: Ponto de Entrada `make install`
- [KB-006](kanban/cards/KB-006.md) — Ingress com Traefik
- [KB-007](kanban/cards/KB-007.md) — cert-manager + Cloudflare DNS-01
- [KB-008](kanban/cards/KB-008.md) — Sealed Secrets
- [KB-009](kanban/cards/KB-009.md) — Primeira Aplicação: Glance (Homepage)
- [KB-010](kanban/cards/KB-010.md) — PostgreSQL + pgAdmin

---

## In Progress (max: 1)

_Sem itens no momento._

---

## Review (max: 3)

- [KB-001](kanban/cards/KB-001.md) — Estrutura do Repositório

---

## Done

_Sem itens no momento._

---

## Como usar

- Cada item segue o formato: `- [KB-XXX](kanban/cards/KB-XXX.md) — Título breve`
- Detalhes completos de cada card estão em `kanban/cards/KB-XXX.md`
- Respeitar os limites de WIP antes de mover itens para uma coluna
- Ao mover um card, atualizar tanto este board quanto o histórico no arquivo do card
