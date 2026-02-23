# Cert-Manager

## Deploy with Argo CD

```bash
argocd app create cert-manager \
    --repo https://github.com/tewing/homelab \
    --path apps/cert-manager \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace cert-manager \
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
