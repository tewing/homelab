# Ubuntu

## Deploy with Argo CD

```bash
APP=ubuntu
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true

argocd app sync "$APP"
```

## Post-install steps

### Launch a shell in the Ubuntu pod

```bash
kubectl exec -it -n ubuntu ubuntu-ubuntu -- /bin/bash
```
