# CloudNative-PG

## Deploy with Argo CD

```bash
argocd app create cloudnative-pg \
    --repo https://github.com/tewing/homelab \
    --path apps/cloudnative-pg \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace postgres \
    --sync-option CreateNamespace=true \
    --sync-option ServerSideApply=true
```

## Start a cluster

```bash
kubectl apply -f cluster.yaml
```

## Inspect clusters

```bash
kubectl get cluster -A
kubectl get cluster <CLUSTERNAME> --watch
```

Wait for the status to report `Cluster in healthy state` before proceeding.

## Create database credentials

### TeslaMate

```bash
kubectl create secret generic cluster-postgres-teslamate \
  --namespace postgres \
  --from-literal=username=teslamate \
  --from-literal=password=zzzzz
```

### Keycloak

```bash
kubectl create secret generic cluster-postgres-keycloak \
  --namespace postgres \
  --from-literal=username=keycloak-db-user \
  --from-literal=password=zzzzz
```

## Create databases

```bash
kubectl apply -f db-teslamate.yaml
kubectl apply -f db-*.yaml
```

## Connect to the database

```bash
kubectl port-forward -n postgres svc/postgres-rw 5432:5432
# In another terminal:
psql -h localhost -U teslamate -d teslamate
\dt+
```
