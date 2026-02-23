# Cloudflare Tunnel

## Deploy with Argo CD

```bash
argocd app create cloudflare \
  --repo https://github.com/tewing/homelab \
  --path apps/cloudflare \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace cloudflare \
  --sync-option CreateNamespace=true \
  --sync-option ServerSideApply=true
```

## Post-install steps

### Create the tunnel

Open Cloudflare → Account home → **Tunnels** and create the tunnel:
https://dash.cloudflare.com/d634a093d69af40e88d14bfbc799d1c4/tunnels

### Create tunnel secrets

```bash
cp ~/.cloudflared/*.json ./credentials.json
kubectl create secret generic config-json-file-secret -n cloudflare --from-file=credentials.json
kubectl create secret generic cert-pem-file-secret -n cloudflare --from-file=~/.cloudflared/cert.pem
```

### Verify the tunnel

Return to Cloudflare → Account home → **Tunnels** and confirm the connection:
https://dash.cloudflare.com/d634a093d69af40e88d14bfbc799d1c4/tunnels

### Add DNS CNAME

Create a `*.<DOMAIN>` CNAME pointing to the tunnel:
https://dash.cloudflare.com/d634a093d69af40e88d14bfbc799d1c4/te-lab.org/dns/records
