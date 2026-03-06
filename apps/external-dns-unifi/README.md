# external-dns-unifi

## Deploy with Argo CD

```bash
APP=external-dns-unifi
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace external-dns \
    --sync-option CreateNamespace=true
argocd app sync $APP   
```

```bash
kubectl create secret generic external-dns-unifi-secret  \
  --namespace external-dns \
  --from-literal=api-key=zzzzzz
```
