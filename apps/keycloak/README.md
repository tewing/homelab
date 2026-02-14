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
kubectl create secret generic postgres-credentials \
  -n teslamate \
  --from-literal=DATABASE_HOST=postgres-rw.postgres.svc \
  --from-literal=DATABASE_NAME=teslamate \
  --from-literal=DATABASE_USER=teslamate \
  --from-literal=DATABASE_PASS=zzz
```

## Create encryption key (for internal storage of Tesla OAuth secret)

```bash
kubectl create secret generic encryption-key \
  -n teslamate \
  --from-literal=ENCRYPTION_KEY=zzz11122333
```

## Retrieve Grafana admin password

```bash
kubectl get secret teslamate-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```
