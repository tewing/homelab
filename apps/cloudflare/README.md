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