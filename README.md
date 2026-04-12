# Richie Homelab - GitOps com k3s e ArgoCD

Este repositório contém a configuração completa (Infra e Apps) do meu homelab, gerenciado via práticas de GitOps utilizando ArgoCD e k3s.

## 🚀 Arquitetura
- **Sistema Operacional**: Fedora Server (IP Fixo: `192.168.15.15`).
- **Cluster**: [k3s](https://k3s.io/) (Single Node).
- **GitOps**: [ArgoCD](https://argoproj.github.io/cd/) monitorando este repositório privado.
- **Ingress Controller**: Traefik (nativo do k3s).
- **Certificados**: Cert-Manager com CA Local (HTTPS auto-assinado).
- **Segredos**: [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) (Bitnami) para versionamento seguro de senhas.
- **Armazenamento**: HostPath mapeado para `/home/elis/data` com permissões para UID:GID 1000.

## 📂 Estrutura do Repositório
- `bootstrap/`: Scripts Bash para preparar o SO e instalar o cluster do zero.
- `infra/`: Componentes base do sistema (namespaces, cert-manager, etc).
- `apps/`: Manifestos das aplicações finais (Nextcloud, qBittorrent, Kavita, etc).
- `clusters/`: O padrão "App of Apps" que orquestra a instalação de tudo.

## 🛠️ Instalação (Disaster Recovery)
Caso precise reinstalar o servidor do zero em um novo disco:
1. Instale o Fedora Server e configure o IP `192.168.15.15`.
2. Clone este repositório.
3. Garanta que o seu Personal Access Token do GitHub esteja em `bootstrap/.env` ou no arquivo `/home/elis/github_token`.
4. Execute os scripts em ordem:
   ```bash
   cd bootstrap
   ./01-setup-fedora.sh
   ./02-install-k3s.sh
   ./03-setup-argocd.sh
   ```

## 🔐 Gerenciando Segredos (Sealed Secrets)
Nunca comite senhas em texto puro. Para adicionar um novo segredo:
1. Crie o secret localmente (sem aplicar):
   `kubectl create secret generic meu-app-secret --from-literal=PASSWORD=minhasenha --dry-run=client -o yaml > secret-raw.yaml`
2. Criptografe usando o `kubeseal`:
   `kubeseal < secret-raw.yaml > sealed-secret.yaml`
3. Comite o arquivo `sealed-secret.yaml` e delete o `secret-raw.yaml`. O ArgoCD aplicará o arquivo criptografado e o cluster criará o Secret real automaticamente.

## 🌐 Acesso às Aplicações
Todos os serviços utilizam o domínio `cusin-server.duckdns.org` resolvendo para o IP interno:
- **Dashboard Principal**: [https://homepage.cusin-server.duckdns.org](https://homepage.cusin-server.duckdns.org)
- **Torrent**: [https://qbittorrent.cusin-server.duckdns.org](https://qbittorrent.cusin-server.duckdns.org)
- **Arquivos**: [https://files.cusin-server.duckdns.org](https://files.cusin-server.duckdns.org)
- **E-books (Kavita)**: [https://kavita.cusin-server.duckdns.org](https://kavita.cusin-server.duckdns.org)
- **Nuvem (Nextcloud)**: [https://cloud.cusin-server.duckdns.org](https://cloud.cusin-server.duckdns.org)

> **Nota sobre HTTPS**: Como os certificados são gerados por uma CA Local, seu navegador mostrará um aviso de segurança. Para resolver, importe o certificado raiz gerado pelo `cert-manager` no seu computador/celular.
