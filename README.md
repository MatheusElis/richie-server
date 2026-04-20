# richie-server — Homelab Kubernetes

Cluster Kubernetes reproduzível em hardware single-node. Um único comando recria toda a infraestrutura do zero.

```bash
make install
```

## Pré-requisitos

- Ubuntu 24.04 LTS
- Acesso SSH ou execução local com sudo
- Chave do Sealed Secrets gerada (`make gen-keys`)

## Documentação

| Documento | Descrição |
|-----------|-----------|
| [docs/arquitetura.md](docs/arquitetura.md) | Visão geral da stack e decisões técnicas |
| [docs/acesso.md](docs/acesso.md) | Como acessar os serviços localmente |
| [docs/como-adicionar-app.md](docs/como-adicionar-app.md) | Passo a passo para adicionar novo app via GitOps |
| [docs/sealed-secrets.md](docs/sealed-secrets.md) | Como criar e gerenciar secrets |
| [docs/hardware.md](docs/hardware.md) | Especificações do hardware |

## Stack

| Camada | Ferramenta |
|--------|-----------|
| Orquestrador | Makefile |
| Configuração OS + K3s | Ansible |
| Kubernetes | K3s v1.32.3 |
| GitOps | ArgoCD (App of Apps) |
| Ingress | Traefik v3 |
| TLS | cert-manager + Cloudflare DNS-01 |
| Secrets | Sealed Secrets |

## Estrutura do Repositório

```
richie-server/
├── Makefile                    # Ponto de entrada único
├── ansible/                    # Configuração do OS e bootstrap do K3s
│   ├── inventory/
│   ├── roles/
│   └── playbooks/
├── argocd/
│   ├── bootstrap/              # Manifesto root-app (aplicado 1x pelo Ansible)
│   └── apps/                   # Application CRDs — um arquivo por app
├── apps/                       # Conteúdo de cada app (values, configmaps, manifests)
│   └── <app>/
├── secrets/                    # SealedSecrets compartilhados entre múltiplos apps
└── docs/                       # Documentação técnica
```
