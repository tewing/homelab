# Keycloak

## Created with:

```bash
argocd app create keycloak \
    --repo https://github.com/tewing/homelab \
    --path apps/keycloak \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace keycloak \
    --sync-option CreateNamespace=true
```

## Create database credentials secret

```bash
kubectl create secret generic keycloak-db-credentials \
  --from-literal=db-password='zzzzzzz' \
  --from-literal=db-username=keycloak-db-user
```

## retrieve admin password

```bash
kubectl get secret -n keycloak keycloak-credentials \
   -o jsonpath="{.data.admin-password}" | base64 -d; echo  
```





