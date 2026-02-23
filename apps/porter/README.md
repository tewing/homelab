# Porter OpenClaw instance 🤖

This app deploys an OpenClaw instance (nicknamed **Porter**) to run an
additional OpenClaw installation. It uses the upstream
[`openclaw` Helm chart](https://github.com/serhanekicii/openclaw-helm) with
homelab-specific values for:

- its own environment Secret (`porter-openclaw-env-secret`)
- unique ingress host (`porter.example.com`)
- identity tweaks inside `openclaw.json` so sessions clearly appear as Porter

## Prerequisites

1. **Secret with runtime tokens** – run once before the app syncs:

   ```bash
   kubectl create secret generic porter-openclaw-env-secret \
     -n openclaw \
     --from-literal=ANTHROPIC_API_KEY=<redacted> \
     --from-literal=OPENAI_API_KEY=<redacted> \
     --from-literal=OPENCLAW_GATEWAY_TOKEN=<redacted> \
     --from-literal=SLACK_BOT_TOKEN=<optional> \
     --from-literal=SLACK_APP_TOKEN=<optional>
   ```

## Deploying via Argo CD

Add `apps/porter` to Argo:

```bash
APP=porter
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace openclaw \
    --sync-option CreateNamespace=true
```

## Configuration

Everything lives in `values.yaml`. Key things you will likely change:

- `openclaw.app-template.ingress.main.hosts[0].host` – set to a real FQDN
- `openclaw.app-template.controllers.main.containers.main.envFrom` – swap in a
  different Secret name if you don’t want the default
- `openclaw.app-template.configMaps.config.data["openclaw.json"]` – tune agent
  identities, tools, timezone, etc.

## Updating the upstream chart

We pin the dependency to version `1.3.19`. Run `helm repo update` and bump the
version in `Chart.yaml` if the upstream chart adds features we need.
