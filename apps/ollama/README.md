# Ollama

Local large language model runner via Ollama.

## Deploy with Argo CD

```bash
APP=ollama
argocd app create "$APP" \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true
argocd app sync $APP
```

## Configuration

### Enable GPU support

Edit `values.yaml` and set:

```yaml
ollama:
  ollama:
    gpu:
      enabled: true
      type: nvidia  # or amd
```

### Pull models at startup

```yaml
ollama:
  ollama:
    models:
      pull:
        - llama3.2
        - mistral
```

### Enable ingress

```yaml
ollama:
  ingress:
    enabled: true
    className: traefik
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: ollama.te-lab.org
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: ollama-tls
        hosts:
          - ollama.te-lab.org
```

### test ollama
```bash
OLLAMA_HOST=http://ollama.example.com:80 ollama run gpt-oss:20b  "respond with ok"
```
