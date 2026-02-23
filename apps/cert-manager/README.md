# Cert-Manager

## Deploy with Argo CD

```bash
APP=cert-manager
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true
```

## Post-install steps

### Configure Cloudflare DNS-01

```bash
kubectl create secret generic cloudflare-api-token-secret \
  --namespace cert-manager \
  --from-literal=api-token='<TOKEN>'
```

### Create ClusterIssuer

```bash
kubectl apply -f clusterissuer.yaml
```
