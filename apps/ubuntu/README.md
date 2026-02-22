# Keycloak

## Created with:

```bash
APP=ubuntu
argocd app create $APP \
    --repo https://github.com/tewing/homelab \
    --path apps/$APP \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $APP \
    --sync-option CreateNamespace=true

argocd app sync $APP
```


## launch a shell in the ubuntu pod
k exec -it -n ubuntu ubuntu-ubuntu -- /bin/bash