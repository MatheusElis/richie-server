# Instruções do Projeto — Richie Server (Homelab)

## Idioma

- O idioma oficial do projeto é **Português Brasil (pt-BR)**.
- Toda comunicação, documentação, commits, nomes de branches, comentários em código e cards Kanban devem ser escritos em português.

## Metodologia Kanban

Este projeto segue rigorosamente a **metodologia Kanban**. As seguintes regras devem ser cumpridas sem exceção:

### Estrutura do Board

O board Kanban está em `KANBAN.md` na raiz do repositório. Cada card possui documentação detalhada em `kanban/cards/KB-XXX.md`.

### Colunas e Limites de WIP

| Coluna      | Limite |
|-------------|--------|
| Backlog     | ∞      |
| To Do       | ∞      |
| In Progress | 1      |
| Review      | 3      |
| Done        | ∞      |

### Regras de Movimentação

1. **Nenhum card pode ser movido de coluna sem confirmação explícita do dono do projeto.**
2. Os limites de WIP devem ser respeitados — não mover um card para uma coluna que já atingiu seu limite.
3. Toda movimentação deve ser registrada no histórico do card (`kanban/cards/KB-XXX.md`).
4. Nenhuma etapa pode ser pulada — o fluxo é sempre: Backlog → To Do → In Progress → Review → Done.

### Criação de Cards

- Cada card segue o template em `kanban/TEMPLATE.md`.
- Cards devem ter descrição clara, critérios de aceite, e notas técnicas quando aplicável.
- O ID segue o padrão sequencial: `KB-001`, `KB-002`, etc.

## Hardware

Servidor único (single-node) com as seguintes especificações:

| Componente     | Detalhes                                      |
|----------------|-----------------------------------------------|
| **Hostname**   | cusin                                         |
| **CPU**        | Intel Core i5-3570 @ 3.40GHz (4 cores, 1 thread/core, max 3.8GHz) |
| **RAM**        | 7.6 GB (+ 4 GB Swap)                          |
| **Disco**      | SSD 223.6 GB (AS-240) — montado em `/`        |
| **Rede**       | Interface `eno1` — IP local: 192.168.31.55/24 |
| **OS**         | Ubuntu 24.04.4 LTS (Noble Numbat)             |
| **Kernel**     | 6.8.0-110-generic x86_64                      |

### Observações de Hardware

- Máquina single-node: o cluster Kubernetes rodará tudo em um único host.
- Recursos modestos — escolhas de stack devem levar isso em conta (ex: K3s ao invés de K8s full).
- Disco único: não há redundância de armazenamento local.

## Objetivo do Projeto

Construir um cluster Kubernetes **reproduzível** em cima deste hardware. O critério principal é:

> **Em caso de troca de hardware, um único `make install` deve recriar toda a infraestrutura do zero.**

### Princípios Técnicos

- Tudo como código (Infrastructure as Code)
- Nenhuma configuração manual — qualquer passo manual deve ser automatizado
- Reproduzibilidade total: o repositório é a fonte de verdade

## Stack Técnica

### Decisões Definidas

| Camada | Ferramenta | Justificativa |
|--------|-----------|---------------|
| **Orquestrador** | Makefile | Ponto de entrada único (`make install`), zero dependências, orquestra as demais ferramentas |
| **Configuração do OS / Bootstrap K3s** | Ansible | Idempotente, ideal para configuração de bare metal, escalável para multi-node no futuro |
| **Kubernetes** | K3s | Leve, ideal para hardware modesto (i5-3570 / 7.6 GB RAM), single-node |
| **GitOps** | ArgoCD | Padrão App of Apps — adicionar/remover apps via Git, sem intervenção manual |
| **Identity Provider** | Authentik | SSO centralizado, Forward Auth via Traefik, OIDC nativo para apps compatíveis |

### Padrão GitOps — App of Apps

- O ArgoCD é bootstrapado pelo Ansible como parte do `make install`
- A partir daí, **tudo é gerenciado via GitOps**: o repositório é a fonte de verdade
- Novos apps são adicionados criando manifests no repositório — ArgoCD sincroniza automaticamente
- Nenhuma configuração de app deve ser feita manualmente no cluster

### Fluxo do `make install`

```
make install
    └── Ansible Playbook
        ├── Configura o OS (kernel params, dependências)
        ├── Instala e configura o K3s
        └── Aplica o manifesto inicial do ArgoCD
            └── ArgoCD (App of Apps) sincroniza o restante
```

### Ferramentas Fora do Escopo (por ora)

- **Terraform** — não se aplica ao cenário bare metal atual; pode ser adicionado no futuro se houver migração para cloud
- **Helm direto** — gerenciado pelo ArgoCD, não executado manualmente

## Regras Gerais

- Este arquivo será complementado conforme o projeto evolui.
- Novas definições de tecnologias, padrões de código, e convenções serão adicionadas aqui à medida que forem decididas.

---

## Estado Atual do Cluster (pós KB-001 a KB-013, KB-024)

### Versões em Produção

| Componente | Versão |
|---|---|
| K3s | v1.32.3+k3s1 |
| Kubernetes | v1.32.3 |
| containerd | 2.0.4-k3s2 |
| ArgoCD Helm chart | argo-cd-9.5.2 (app v3.3.7) |
| Sealed Secrets | 0.27.0 |
| Helm | v3.20.2 |

### Aplicações Rodando

| App | Namespace | URL | Status |
|---|---|---|---|
| ArgoCD | argocd | https://argocd.bisnaguete.xyz | ✅ Healthy |
| Authentik | authentik | https://auth.bisnaguete.xyz | ✅ Healthy |
| Glance | glance | https://home.bisnaguete.xyz | ✅ Healthy |
| pgAdmin | pgadmin | https://pgadmin.bisnaguete.xyz | ✅ Healthy |
| PostgreSQL | postgresql | interno (sem ingress) | ✅ Healthy |
| Traefik | traefik | interno | ✅ Healthy |
| cert-manager | cert-manager | interno | ✅ Healthy |
| Sealed Secrets | kube-system | interno | ✅ Healthy |

### Estrutura de Diretórios do Repositório

```
richie-server/
├── Makefile                        # Ponto de entrada: make install
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.yml               # Host: cusin (localhost)
│   │   └── group_vars/all.yml      # Variáveis globais
│   ├── playbooks/
│   │   └── site.yml                # Playbook principal
│   └── roles/
│       ├── common/                 # OS: pacotes, timezone, swap, kernel, diretórios mídia
│       ├── k3s/                    # Instalação K3s + kubeconfig
│       ├── sealed-secrets/         # Restaurar chave no cluster
│       └── argocd/                 # Helm install + SealedSecret + root-app
├── argocd/
│   ├── apps/                       # ArgoCD Application CRDs
│   │   ├── cert-manager.yaml
│   │   ├── authentik.yaml
│   │   ├── glance.yaml
│   │   ├── pgadmin.yaml
│   │   ├── postgresql.yaml
│   │   └── traefik.yaml
│   └── bootstrap/
│       ├── root-app.yaml           # App of Apps — aponta para argocd/apps/
│       └── values.yaml             # Helm values do ArgoCD (inclui ingress)
├── apps/                           # Manifests Kubernetes por app
│   ├── authentik/
│   ├── cert-manager/
│   ├── glance/
│   ├── pgadmin/
│   ├── postgresql/
│   ├── sealed-secrets/
│   └── traefik/
├── scripts/
│   └── seal.sh                     # Helper para encriptar secrets
├── secrets/                        # SealedSecrets (encriptados, safe para git)
│   └── argocd-admin-secret.yaml
├── docs/                           # Documentação do projeto
│   ├── acesso.md
│   ├── arquitetura.md
│   ├── como-adicionar-app.md
│   ├── hardware.md
│   └── sealed-secrets.md
└── kanban/                         # Board e cards Kanban
    ├── TEMPLATE.md
    └── cards/KB-XXX.md
```

### Comandos Úteis do Dia a Dia

```bash
# Instalar / recriar tudo do zero
make install

# Verificar estado do cluster
KUBECONFIG=~/.kube/config kubectl get pods -A
KUBECONFIG=~/.kube/config kubectl get applications -n argocd

# Gerar par de chaves Sealed Secrets (apenas uma vez / ao trocar hardware)
make gen-keys

# Encriptar um novo secret
kubeseal --cert ~/.homelab/sealed-secrets-cert.pem -o yaml < secret.yaml > sealed-secret.yaml
```

### Credenciais e Acesso

| Serviço | Usuário | Observação |
|---|---|---|
| ArgoCD | admin | Senha em SealedSecret (`secrets/argocd-admin-secret.yaml`). Futuro: SSO via Authentik (KB-025) |
| pgAdmin | admin@bisnaguete.xyz | Senha em SealedSecret (`apps/pgadmin/sealed-secret.yaml`). Futuro: proxy auth via Authentik (KB-026) |
| Authentik | admin | Senha definida via `/if/flow/initial-setup/`. Secret key em SealedSecret (`apps/authentik/sealed-secret.yaml`) |

### Chaves e Backups Obrigatórios

| Arquivo | Localização | Importância |
|---|---|---|
| Chave privada Sealed Secrets | `~/.homelab/sealed-secrets-key.yaml` | **CRÍTICO** — sem ela não é possível descriptografar nenhum SealedSecret. Guardar em gerenciador de senhas. |
| Certificado público | `~/.homelab/sealed-secrets-cert.pem` | Usado para encriptar novos secrets |

> ⚠️ **Se a chave privada for perdida**, rodar `make rotate-keys` e re-encriptar todos os SealedSecrets do repositório.

### Padrão para Adicionar Novas Aplicações via GitOps

1. Criar manifests em `apps/<nome-do-app>/` (Deployment, Service, Ingress, etc.)
2. Criar `argocd/apps/<nome-do-app>.yaml` (ArgoCD Application CRD)
3. Secrets sensíveis → gerar SealedSecret e salvar em `secrets/` ou `apps/<nome>/`
4. Ingress deve incluir annotation de Forward Auth do Authentik (exceto apps com OIDC nativo)
5. Fazer `git push` — ArgoCD sincroniza automaticamente

### Padrão de Autenticação

O Authentik é o Identity Provider centralizado. Toda app nova DEVE ser protegida por ele.

| Método | Quando usar | Exemplo |
|---|---|---|
| **OIDC nativo** | App suporta SSO via OpenID Connect | ArgoCD, Memos |
| **Forward Auth + External** | Apps *arr (suportam header `Remote-User`) | Prowlarr, Radarr, Sonarr |
| **Forward Auth + Proxy auth** | App suporta auto-login via header | pgAdmin (`REMOTE_USER`), Filebrowser (`X-authentik-username`) |
| **Forward Auth puro** | App sem auth própria | Glance, Transmission, LazyLibrarian, Calibre |

Princípio: **zero dupla autenticação** — o usuário autentica uma vez no Authentik e acessa a app diretamente.

#### Middleware Traefik para Forward Auth

Apps protegidas por Forward Auth usam esta annotation no ingress:
```yaml
traefik.ingress.kubernetes.io/router.middlewares: authentik-authentik@kubernetescrd
```

### DNS e Domínio

- Domínio: `bisnaguete.xyz`
- DNS gerenciado via Cloudflare
- Certificados TLS: cert-manager com ClusterIssuer `letsencrypt-prod` (DNS-01 via Cloudflare)
- Todos os ingresses usam Traefik como IngressClass

### Variáveis Ansible Configuráveis (`ansible/inventory/group_vars/all.yml`)

| Variável | Valor atual | Descrição |
|---|---|---|
| `k3s_version` | v1.32.3+k3s1 | Versão fixada do K3s |
| `k3s_user` | elis | Usuário que recebe o kubeconfig |
| `timezone` | America/Sao_Paulo | Timezone do servidor |
| `homelab_data_dir` | /opt/homelab | Diretório base para dados persistentes |
| `argocd_chart_version` | 7.8.26 | Versão fixada do Helm chart do ArgoCD |
| `project_root` | ~/richie-server | Caminho local do repositório |

### Aplicações Planejadas (Backlog/To Do)

| App | Imagem | URL prevista | Auth | Card |
|---|---|---|---|---|
| Memos | `neosmemo/memos:0.27.1` | `memos.bisnaguete.xyz` | OIDC nativo | KB-023 |
| Transmission | `linuxserver/transmission:4.1.1` | `transmission.bisnaguete.xyz` | Forward Auth | KB-015 |
| Prowlarr | `linuxserver/prowlarr:1.34.1` | `prowlarr.bisnaguete.xyz` | Forward Auth + External | KB-016 |
| Radarr | `linuxserver/radarr:6.1.1` | `radarr.bisnaguete.xyz` | Forward Auth + External | KB-017 |
| Sonarr | `linuxserver/sonarr:4.0.17` | `sonarr.bisnaguete.xyz` | Forward Auth + External | KB-018 |
| LazyLibrarian | `linuxserver/lazylibrarian:e7c7ce2d-ls262` | `lazylibrarian.bisnaguete.xyz` | Forward Auth | KB-019 |
| Calibre | `linuxserver/calibre:9.7.0` | `calibre.bisnaguete.xyz` + `calibre-opds.bisnaguete.xyz` | Forward Auth | KB-020 |
| Filebrowser | `filebrowser/filebrowser:v2.63.2` | `files.bisnaguete.xyz` | Forward Auth + Proxy auth | KB-021 |

### Volume Compartilhado de Mídia (KB-014 — em Review)

```
/opt/homelab/data/media/
├── downloads/        # Transmission deposita aqui
│   ├── complete/
│   └── incomplete/
├── movies/           # Radarr organiza aqui
├── tv/               # Sonarr organiza aqui
└── books/            # LazyLibrarian + Calibre
```

- Diretórios criados via Ansible (role `common`)
- Cada app monta subdiretórios via `hostPath` (single-node)
- PUID=1000 / PGID=1000 (usuário `elis`) para todas as apps de mídia
