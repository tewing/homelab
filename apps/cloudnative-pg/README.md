# CloudNative-PG

Created with:

```bash
argocd app create cloudnative-pg --repo https://github.com/tewing/homelab --path apps/cloudnative-pg --dest-server https://kubernetes.default.svc --dest-namespace cloudnative-pg --sync-option CreateNamespace=true --sync-option ServerSideApply=true
```
