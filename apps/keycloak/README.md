# Keycloak

## Deploy with Argo CD

```bash
APP=keycloak
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true
```

## Post-install steps

### Create database credentials secret

```bash
kubectl create secret generic keycloak-db-credentials \
  --namespace auth \
  --from-literal=db-password='zzzzzzz' \
  --from-literal=db-username=keycloak-db-user
```

### Retrieve admin password

```bash
kubectl get secret -n auth keycloak \
   -o jsonpath="{.data.admin-password}" | base64 -d; echo
```
