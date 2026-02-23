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
kubectl create secret generic openclaw-env-secret -n openclaw \
  --from-literal=ANTHROPIC_API_KEY=sk-ant-xxx \
  --from-literal=OPENCLAW_GATEWAY_TOKEN=your-token
```
