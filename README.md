# Richie Server 🥖

Laboratório de Kubernetes (k3s) e GitOps (ArgoCD) de alta fidelidade no nó **cusin**.

## 🛠️ Comandos Rápidos (Makefile)
- `make install-tools`: Instala Helm e ferramentas auxiliares.
- `make install-k3s`: Instala o cluster k3s.
- `make install-argocd`: Instala o ArgoCD via Helm (Bootstrap).
- `make check-status`: Verifica a saúde do cluster.

## 🚪 Primeiro Acesso (ArgoCD)
Após a instalação bem-sucedida do ArgoCD:

1. **Abra o túnel de acesso:**
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
2. **Acesse no Navegador:** `https://localhost:8080` (Ignore o aviso de certificado SSL, ele é auto-assinado por enquanto).
3. **Credenciais Iniciais:**
   - **Usuário:** `admin`
   - **Senha:** `Bisnaguete0312#`

⚠️ **IMPORTANTE:** Recomendamos alterar a senha na interface do ArgoCD após o primeiro login por segurança.

## 🏗️ Arquitetura
Consulte o arquivo [GEMINI.md](./GEMINI.md) para diretrizes de desenvolvimento e padrões do projeto.
