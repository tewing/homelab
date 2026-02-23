# Porter OpenClaw instance

This app deploys a second OpenClaw stack (nicknamed **Porter**) so we can run an
additional agent alongside the primary installation. It reuses the upstream
[`openclaw` Helm chart](https://github.com/serhanekicii/openclaw-helm) but ships
homelab-specific defaults for:

- a dedicated namespace: `porter`
- its own environment Secret (`porter-openclaw-env-secret`)
- unique ingress host (`porter.example.com` – update for your DNS)
- identity tweaks inside `openclaw.json` so sessions clearly appear as Porter

## Prerequisites

1. **Namespace** (created automatically by Argo CD/App Template when needed).
2. **Secret with runtime tokens** – run once before the app syncs:

   ```bash
   kubectl create secret generic porter-openclaw-env-secret \
     -n porter \
     --from-literal=OPENAI_API_KEY=<redacted> \
     --from-literal=OPENCLAW_GATEWAY_TOKEN=<redacted> \
     --from-literal=SLACK_BOT_TOKEN=<optional> \
     --from-literal=SLACK_APP_TOKEN=<optional>
   ```

3. **Ingress / DNS** – point `porter.example.com` (or whatever host you set in
   `values.yaml`) at your cluster’s ingress controller.

## Deploying via Argo CD

Add `apps/porter` to Argo (following the same pattern as other apps) or install
manually for testing:

```bash
helm dependency update apps/porter
helm upgrade --install porter apps/porter \
  -n porter \
  --create-namespace
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
