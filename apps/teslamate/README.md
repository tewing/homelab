
## Created with:

```bash
argocd app create teslamate \
    --repo https://github.com/tewing/homelab \
    --path apps/teslamate \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace teslamate \
    --sync-option CreateNamespace=true 
```



Create database credentials secret
# Custom user credentials (optional)
kubectl create secret -n teslamate generic postgres-credentials \
  --from-literal=host=postgres-rw.postgres.svc \
  --from-literal=user=teslamate \
  --from-literal=password=sdfsdfq3es \
  --from-literal=database=teslamate

