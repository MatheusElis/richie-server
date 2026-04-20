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
