# Como Adicionar uma Nova Aplicação

Todo novo app segue o padrão GitOps — nenhuma configuração manual no cluster.

## Passo a Passo

### 1. Criar os manifests do app

```bash
mkdir apps/<nome-do-app>/
```

Adicione os arquivos necessários (values Helm, Deployment, Service, Ingress, ConfigMap, SealedSecret).

### 2. Criar o Application CRD do ArgoCD

Crie `argocd/apps/<nome-do-app>.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <nome-do-app>
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: default
  source:
    repoURL: https://github.com/MatheusElis/richie-server
    targetRevision: HEAD
    path: apps/<nome-do-app>
  destination:
    server: https://kubernetes.default.svc
    namespace: <nome-do-app>
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### 3. Criar o Secret (se necessário)

Consulte [sealed-secrets.md](sealed-secrets.md) para criar um SealedSecret e salve em `apps/<nome-do-app>/sealed-secret.yaml`.

### 4. Criar o database (se usar PostgreSQL)

```sql
CREATE DATABASE <nome-do-app>_db;
CREATE USER <nome-do-app>_user WITH PASSWORD 'senha';
GRANT ALL PRIVILEGES ON DATABASE <nome-do-app>_db TO <nome-do-app>_user;
```

### 5. Commit e push

```bash
git add .
git commit -m "feat: adiciona app <nome-do-app>"
git push
```

O ArgoCD detecta a mudança e sincroniza automaticamente.

## Remover uma Aplicação

```bash
rm -rf apps/<nome-do-app>/
rm argocd/apps/<nome-do-app>.yaml
git add . && git commit -m "feat: remove app <nome-do-app>" && git push
```

O ArgoCD (com `prune: true`) remove os recursos do cluster automaticamente.
