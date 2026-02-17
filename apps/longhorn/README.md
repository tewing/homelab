# Longhorn

See also: [K3s guide – Setup Longhorn](https://k3s.guide/docs/storage/setup-longhorn/).

## Prerequisites

Create the backup bucket:

```bash
aws s3 mb s3://longhorn-backup-te --region us-east-1 --profile c9-ia
```

Create the backup credentials secret (use your own credentials; do not commit real keys):

```bash
kubectl create secret generic longhorn-backup-credentials \
  --namespace=longhorn \
  --from-literal=AWS_ACCESS_KEY_ID='YOUR_ACCESS_KEY' \
  --from-literal=AWS_SECRET_ACCESS_KEY='YOUR_SECRET_KEY'
```

## Install

Argo CD can hit issues installing Longhorn, so install via Helm:

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm upgrade --install longhorn longhorn/longhorn --version 1.11.0 --namespace longhorn --create-namespace --values val.yaml
```
