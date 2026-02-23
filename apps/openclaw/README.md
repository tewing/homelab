# Openclaw

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
kubectl create secret generic openclaw-env-secret \
  -n openclaw \
  --from-literal=OPENAI_API_KEY=sk-zzzz \
  --from-literal=OPENCLAW_GATEWAY_TOKEN=zzz111222
```

Download the openclaw workspace from the pod
```bash
   OPENCLAW_POD=$(kubectl get pod -n openclaw -l app.kubernetes.io/name=openclaw -o jsonpath='{.items[0].metadata.name}')
   kubectl cp -n openclaw   -c main           $OPENCLAW_POD:/home/node/.openclaw ~/openclaw/
```



