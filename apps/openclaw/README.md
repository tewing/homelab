# Keycloak

## Created with:

```bash
argocd app create openclaw \
    --repo https://github.com/tewing/homelab \
    --path apps/openclaw \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace openclaw \
    --sync-option CreateNamespace=true
```

## Create database credentials secret

```bash
kubectl create secret generic keycloak-db-credentials \
  --from-literal=db-password='zzzzzzz' \
  --from-literal=db-username=keycloak-db-user
```



