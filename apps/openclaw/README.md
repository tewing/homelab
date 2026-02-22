# Keycloak

## Created with:

```bash
argocd app create openclaw \
    --repo https://github.com/tewing/homelab \
    --path apps/openclaw \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace openclaw \
    --sync-option CreateNamespace=true
```

## Create  secret

```bash
kubectl create secret generic openclaw-env-secret -n openclaw \
  --from-literal=ANTHROPIC_API_KEY=sk-ant-xxx \
  --from-literal=OPENCLAW_GATEWAY_TOKEN=your-token
```



