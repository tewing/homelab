# OpenClaw

## Deploy with Argo CD

```bash
APP=openclaw
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true
```

## Configure secrets

```bash
kubectl create secret generic openclaw-env-secret \
  -n openclaw \
  --from-literal=OPENAI_API_KEY=sk-zzzz \
  --from-literal=OPENCLAW_GATEWAY_TOKEN=zzz111222
```


## Download the openclaw workspace from the pod
```bash
OPENCLAW_POD=$(kubectl get pod -n openclaw -l app.kubernetes.io/name=openclaw -o jsonpath='{.items[0].metadata.name}')
BACKUP_DIR=~/openclaw/$(date +%Y-%m-%d)
mkdir -p "$BACKUP_DIR"
kubectl cp -n openclaw -c main "$OPENCLAW_POD:/home/node/.openclaw" "$BACKUP_DIR/"
```

