# Homelab 🏡

Operational notes, manifests, and automation for my physical K3s cluster. Everything here reflects the way I run the cluster today: bare-metal nodes, GitOps with Argo CD, and a small Raspberry Pi 5 utility box.

## Overview

- **K3s everywhere** – Lightweight Kubernetes with embedded etcd across all control-plane nodes.
- **GitOps-first** – Apps (and Argo itself) are expressed as Helm values / manifests inside this repo, so the cluster state is driven entirely from Git.
- **Homelab-friendly hardware** – Low-power mini PCs for the control plane plus a Pi 5 for edge / automation work.

## Cluster topology

| Node | Role(s) | Hardware & OS | Notes |
|------|---------|---------------|-------|
| `k1` | Control-plane + worker | [Beelink SER6 Pro Mini PC](https://www.amazon.com/dp/B0FQT44ZCJ?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) — AMD Ryzen 7 7735HS, 32 GB RAM, NVMe SSD, Ubuntu Server 24.04 | Runs etcd + system workloads |
| `k2` | Control-plane + worker | Same spec as `k1` | Adds redundancy for etcd/HA + general workloads |
| `k3` | Control-plane + worker | Same spec as `k1` | Keeps quorum even if one node is down |
| `k4` | Edge/utility worker | Raspberry Pi 5 8 GB w/ [passive case](https://www.amazon.com/dp/B0B55SWRCY?ref=ppx_yo2ov_dt_b_fed_asin_title), [NVMe hat](https://www.amazon.com/dp/B0CK2FCG1K?ref=ppx_yo2ov_dt_b_fed_asin_title), [PSU kit](https://www.amazon.com/dp/B0CPPGGDQT?ref=ppx_yo2ov_dt_b_fed_asin_title); runs Raspberry Pi OS 64-bit | Handles lightweight services, out-of-band jobs, and serves as the cluster’s out-of-band node |

K3s runs with embedded etcd on `k1–k3`. Worker taints/labels are managed via the manifests under `k3s/`.

## GitOps + Argo CD

Argo CD is installed directly in-cluster using the Helm values found at [`k3s/argo/values.yaml`](k3s/argo/values.yaml):

```bash
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f k3s/argo/values.yaml
```

Once Argo is up, sync the root application(s) defined under `apps/` to roll out individual services (cert-manager, Cloudflare Tunnel, TeslaMate, etc.).

## Repository layout

```
.
├── k3s/
│   ├── argo/             # Helm values + bootstrap manifests for Argo CD
│   └── cluster/          # Base manifests, node labels, storage classes, etc.
├── apps/
│   ├── <app>/README.md   # App-specific deploy/runbooks
│   └── <app>/values.yaml # Helm overrides consumed by Argo
├── scripts/              # Helper scripts (maintenance, backups, etc.)
└── docs/                 # Deep dives, troubleshooting notes
```

## Operating the cluster

- **Bootstrap** – Bring up K3s on `k1–k3` (see `k3s/cluster/` for config) and join `k4` as a worker.
- **Install Argo CD** – Use the command above; Argo will continuously reconcile against this repository.
- **Deploy apps** – Add/update values inside `apps/<name>/values.yaml` + README, commit, and let Argo sync.
- **Secrets** – Store sensitive values as Kubernetes secrets generated out-of-band (see each app README for the exact `kubectl create secret …` commands).

## Hardware references

- Control-plane/workers (`k1–k3`): [Beelink SER6 Pro Mini PC](https://www.amazon.com/dp/B0FQT44ZCJ?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1)
- Utility node (`k4`):
  - [Raspberry Pi 5 Kit](https://www.amazon.com/dp/B0B55SWRCY?ref=ppx_yo2ov_dt_b_fed_asin_title)
  - [NVMe Base / Active Cooler](https://www.amazon.com/dp/B0CK2FCG1K?ref=ppx_yo2ov_dt_b_fed_asin_title)
  - [Official USB-C 27W PSU](https://www.amazon.com/dp/B0CPPGGDQT?ref=ppx_yo2ov_dt_b_fed_asin_title)

## Resources

- [K3s documentation](https://docs.k3s.io/)
- [Argo CD documentation](https://argo-cd.readthedocs.io/en/stable/)

---

See [LICENSE](LICENSE) for details.
