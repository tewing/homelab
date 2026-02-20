# CloudNative-PG

## Created with:

```bash
argocd app create cloudflare \
    --repo https://github.com/tewing/homelab \
    --path apps/cloudflare \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace cloudflare \
    --sync-option CreateNamespace=true \
    --sync-option ServerSideApply=true
```


## Create tunnel secrets with:
```bash
cp ~/.cloudflared/*.json ./credentials.json
kubectl create secret generic config-json-file-secret -n cloudflare --from-file=credentials.json
kubectl create secret generic cert-pem-file-secret -n cloudflare --from-file=~/.cloudflared/cert.pem
```