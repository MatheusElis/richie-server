# Richie Homelab - GitOps Profissional com k3s e ArgoCD

Este repositório contém a infraestrutura completa do meu homelab, projetada com foco em automação (Makefile), rastreabilidade (GitOps individualizado) e simplicidade.

## 🚀 Arquitetura do Sistema
- **SO**: Fedora Server (IP Fixo: `192.168.15.15`).
- **Orquestração**: [k3s](https://k3s.io/) (Kubernetes leve).
- **GitOps**: [ArgoCD](https://argoproj.github.io/cd/) seguindo o padrão **App of Apps**.
- **Ingress**: Traefik (nativo do k3s) com HTTPS local.
- **Banco de Dados**: PostgreSQL centralizado (instância única para todas as aplicações).
- **Armazenamento**: Persistência no host em `$HOME/data/` com permissões automáticas.

---

## 📁 Estrutura do Repositório
```text
.
├── Makefile                # Comandos principais (install, teardown, test)
├── bootstrap/              # Scripts bash de configuração inicial e SO
├── clusters/               # Definições das aplicações para o ArgoCD
│   ├── apps/               # Uma Application para cada serviço do usuário
│   └── infra/              # Uma Application para cada componente base
├── infra/                  # Manifestos da infraestrutura (Postgres, Certs)
└── apps/                   # Manifestos das aplicações finais
    ├── [app-name]/         # Pasta única contendo PV, PVC, Deploy, Service e Ingress
    └── shared-storage/     # Volumes compartilhados (Media e Downloads)
```

---

## 🛠️ Operação Básica (Makefile)

O ciclo de vida do homelab é gerenciado pelo `Makefile` na raiz:

- **Instalação Total**: `make install`
  *(Prepara o Fedora, instala k3s, configura autenticação, sobe o ArgoCD e testa tudo)*.
- **Limpeza Total (Reset)**: `make teardown`
  *(Desinstala o cluster e apaga todos os dados em $HOME/data)*.
- **Validar Saúde**: `make test`
  *(Executa testes de curl em todos os endpoints de Ingress)*.

---

## 🔐 Usuários e Senhas

O homelab utiliza um sistema de **Autenticação Global**. As credenciais são definidas no arquivo `bootstrap/.env` e injetadas no Kubernetes via Secret (`homelab-auth`).

### 1. Credenciais Predefinidas
Atualmente configurado como:
- **Usuário**: `elis`
- **Senha**: `pamonha0312`

### 2. Onde elas se aplicam?
- **PostgreSQL**: Usuário root do banco.
- **Nextcloud**: Usuário administrador criado automaticamente.
- **Joplin**: Credenciais de conexão com o banco.
- **ArgoCD**: O usuário inicial é `admin`. A senha deve ser obtida com:
  `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

*Nota: Aplicações como qBittorrent e Kavita possuem setups iniciais próprios (ex: admin/adminadmin).*

---

## ➕ Como adicionar uma nova aplicação

Para adicionar um novo serviço (ex: `my-app`):

1. **Crie a pasta do app**: `mkdir -p apps/my-app`
2. **Crie o manifesto consolidado**: `apps/my-app/my-app.yaml`
   - Inclua no mesmo arquivo: `PersistentVolume` (apontando para `$HOME/data/configs/my-app`), `PersistentVolumeClaim`, `Deployment`, `Service` e `Ingress`.
3. **Crie a Application no Argo**: Crie `clusters/apps/my-app.yaml` apontando para `path: apps/my-app`.
4. **Prepare a pasta no host**: Adicione a criação do diretório em `bootstrap/01-setup-fedora.sh`.
5. **Commit e Push**: O ArgoCD detectará o novo arquivo em `clusters/apps/` e criará um novo card no painel automaticamente.

---

## 🌐 Endpoints Disponíveis
Acesse via rede local (aceitando o certificado autoassinado):

- **Dashboard**: [https://homepage.cusin-server.duckdns.org](https://homepage.cusin-server.duckdns.org)
- **GitOps (ArgoCD)**: [https://argocd.cusin-server.duckdns.org](https://argocd.cusin-server.duckdns.org)
- **Arquivos**: [https://files.cusin-server.duckdns.org](https://files.cusin-server.duckdns.org)
- **Nuvem**: [https://cloud.cusin-server.duckdns.org](https://cloud.cusin-server.duckdns.org)
- **Torrent**: [https://qbittorrent.cusin-server.duckdns.org](https://qbittorrent.cusin-server.duckdns.org)
- **Leitura**: [https://kavita.cusin-server.duckdns.org](https://kavita.cusin-server.duckdns.org)
- **E-books**: [https://calibre.cusin-server.duckdns.org](https://calibre.cusin-server.duckdns.org)
- **Notas**: [https://joplin.cusin-server.duckdns.org](https://joplin.cusin-server.duckdns.org)

---

## ⚠️ Dicas de Resolução de Problemas
- **SELinux**: Se uma app não conseguir escrever, rode `sudo restorecon -Rv $HOME/data`.
- **Sincronização**: Se o ArgoCD demorar a atualizar, use o botão **Refresh** no card da aplicação.
- **Logs**: Use `kubectl logs -n apps -l app=[nome-do-app]` para investigar falhas.
