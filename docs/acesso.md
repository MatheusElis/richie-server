# Como Acessar os Serviços

## Pré-requisito

O acesso funciona apenas na rede local. Certifique-se de estar conectado à mesma rede que o servidor (`192.168.31.55`).

## DNS Local

Para que os subdomínios resolvam na sua máquina local, adicione ao `/etc/hosts` (ou configure no roteador):

```
192.168.31.55  home.bisnaguete.xyz
192.168.31.55  pgadmin.bisnaguete.xyz
192.168.31.55  memos.bisnaguete.xyz
192.168.31.55  traefik.bisnaguete.xyz
```

> **Alternativa:** Configure o DNS wildcard `*.bisnaguete.xyz → 192.168.31.55` no seu roteador para não precisar adicionar cada subdomínio manualmente.

## Serviços Disponíveis

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Glance | https://home.bisnaguete.xyz | Dashboard / Homepage |
| Memos | https://memos.bisnaguete.xyz | App de notas (SSO via Authentik OIDC) |
| pgAdmin | https://pgadmin.bisnaguete.xyz | Administração do PostgreSQL |
| ArgoCD | https://argocd.bisnaguete.xyz | GitOps dashboard (SSO via Authentik OIDC) |
| Authentik | https://auth.bisnaguete.xyz | Identity Provider / SSO |
| Traefik | https://traefik.bisnaguete.xyz | Dashboard do Ingress |

## TLS

Os certificados são emitidos pelo Let's Encrypt via DNS-01 challenge (Cloudflare). Na primeira execução, aguarde alguns minutos para os certificados serem emitidos.

## ArgoCD

O ArgoCD possui Ingress configurado em `https://argocd.bisnaguete.xyz` com SSO via Authentik.
