# TeslaMate

## Deploy with Argo CD

```bash
APP=teslamate
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
kubectl create secret generic postgres-credentials \
  -n teslamate \
  --from-literal=DATABASE_HOST=postgres-rw.postgres.svc \
  --from-literal=DATABASE_NAME=teslamate \
  --from-literal=DATABASE_USER=teslamate \
  --from-literal=DATABASE_PASS=zzz
```

### Create encryption key

Used for storing the Tesla OAuth secret.

```bash
kubectl create secret generic encryption-key \
  -n teslamate \
  --from-literal=ENCRYPTION_KEY=zzz11122333
```

### Retrieve Grafana admin password

```bash
kubectl get secret teslamate-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```
