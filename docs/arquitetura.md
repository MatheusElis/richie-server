# Arquitetura

## Visão Geral

O cluster roda em um único node físico (hostname: `cusin`) com Ubuntu 24.04 LTS. O objetivo é reproduzibilidade total: um `make install` recria tudo do zero.

## Fluxo do `make install`

```
make install
  └── Ansible Playbook
      ├── Configura o OS (kernel params, dependências, timezone)
      ├── Cria diretórios do host (/opt/homelab/)
      ├── Instala e configura o K3s
      ├── Importa a chave do Sealed Secrets
      └── Aplica o manifesto root-app do ArgoCD
          └── ArgoCD (App of Apps) sincroniza o restante via GitOps
```

## Stack Técnica

| Camada | Ferramenta | Justificativa |
|--------|-----------|---------------|
| Orquestrador | Makefile | Ponto de entrada único, zero dependências |
| Configuração OS + K3s | Ansible | Idempotente, ideal para bare metal |
| Kubernetes | K3s v1.32.3+k3s1 | Leve, ideal para hardware modesto |
| GitOps | ArgoCD v2.14 | App of Apps — tudo via Git |
| Ingress | Traefik v3 | Ingress padrão K8s, HTTP→HTTPS global |
| TLS | cert-manager + Cloudflare | Wildcard *.bisnaguete.xyz via DNS-01 |
| Secrets | Sealed Secrets | Secrets encriptados seguros no Git |

## Sync Waves (ArgoCD)

A ordem de deploy das apps é controlada por sync waves:

| Wave | Apps |
|------|------|
| 0 | sealed-secrets |
| 1 | traefik, cert-manager |
| 2 | argocd, postgresql |
| 3 | glance, memos, pgadmin, demais apps |

## Dados Persistentes

Todos os dados persistentes ficam em `/opt/homelab/` no host:

```
/opt/homelab/
├── data/        ← dados de apps (postgresql, etc.)
└── media/       ← futuramente: mídia (jellyfin, books, etc.)
```

Este diretório **não é apagado** pelo `make uninstall`.

## Domínio e Acesso

- Domínio: `bisnaguete.xyz` (Cloudflare)
- Acesso apenas local — não exposto à internet
- Wildcard DNS: `*.bisnaguete.xyz` → `192.168.31.55`
- TLS via Let's Encrypt (DNS-01 challenge)
