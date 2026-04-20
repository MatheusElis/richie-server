# Sealed Secrets

## O que é

Sealed Secrets permite encriptar Kubernetes Secrets e commitá-los com segurança no Git. Apenas o controller no cluster consegue desencriptar.

## Chave Mestra

A chave é gerada manualmente (não pelo cluster) para garantir reproduzibilidade:

```bash
make gen-keys       # gera a chave em ~/.homelab/sealed-secrets-key.yaml
make rotate-keys    # gera nova chave e re-encripta todos os secrets do repo
```

A chave **nunca entra no repositório**. Faça backup de `~/.homelab/sealed-secrets-key.yaml`.

## Como Criar um SealedSecret

### Pré-requisito

```bash
# Instalar kubeseal
brew install kubeseal   # macOS
# ou
curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.0/kubeseal-0.27.0-linux-amd64.tar.gz | tar xz
sudo mv kubeseal /usr/local/bin/
```

### Criar o Secret

```bash
# 1. Criar o Secret comum (não commitar!)
kubectl create secret generic meu-secret \
  --namespace=meu-app \
  --from-literal=password=minhasenha \
  --dry-run=client -o yaml > /tmp/secret.yaml

# 2. Encriptar com kubeseal
kubeseal --format yaml < /tmp/secret.yaml > apps/meu-app/sealed-secret.yaml

# 3. Limpar o arquivo temporário
rm /tmp/secret.yaml
```

### Commitar

```bash
git add apps/meu-app/sealed-secret.yaml
git commit -m "feat: adiciona sealed secret para meu-app"
```

## Cenário: Chave Perdida ou Novo Hardware

Se a chave for perdida (ex: troca de hardware sem backup):

```bash
make gen-keys       # gera nova chave
make rotate-keys    # re-encripta todos os SealedSecrets do repo com a nova chave
git add . && git commit -m "chore: rotate sealed secrets keys"
git push
```
