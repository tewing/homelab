# CloudNative-PG

## Created with:

```bash
argocd app create cloudnative-pg \
    --repo https://github.com/tewing/homelab \
    --path apps/cloudnative-pg \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace postgres \
    --sync-option CreateNamespace=true \
    --sync-option ServerSideApply=true
```


## Start a cluster with:

```bash
kubectl apply -f cluster.yaml
```

## Find all clusters

```bash
kubectl get cluster -A
```

## watch the cluster status:

```bash
kubectl get cluster <CLUSTERNAME> --watch
# Wait for the status to show "Cluster in healthy state".
```

## Create postgres user credentials with:

```bash 
kubectl create secret generic cluster-postgres-teslamate \
  --namespace postgres \
  --from-literal=username=teslamate \
  --from-literal=password=zzzzz 
```


## Connect to the database

```bash
kubectl port-forward svc/postgres-rw 5432:5432
# In another terminal:
psql -h localhost -U teslamate -d teslamate
```
