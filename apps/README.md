# Apps

Helm-based applications deployed to the cluster via Argo CD. Each subdirectory contains a `Chart.yaml`, `values.yaml`, and `README.md` with app-specific deployment instructions.

## ArgoCD Login

Get the ArgoCD server hostname and log in using the initial admin password:

```bash
ARGOCD_SERVER=$(kubectl get ingress -A -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[*].spec.rules[*].host}')
ARGOCD_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

argocd login $ARGOCD_SERVER --password $ARGOCD_ADMIN_PASSWORD --insecure --grpc-web --username admin

echo $ARGOCD_ADMIN_PASSWORD | pbcopy
echo admin password copied to clipboard
echo opening https://$ARGOCD_SERVER
open https://$ARGOCD_SERVER
```
