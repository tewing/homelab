# Homelab 🏡

Operational notes, manifests, and automation for my physical K3s cluster. Everything here reflects the way I run the cluster today: bare-metal nodes, GitOps with Argo CD.  3 X86 nodes, 1 arm64 node.

## Overview

- **K3s everywhere** – Lightweight Kubernetes with embedded etcd across all control-plane nodes.
- **GitOps-first** – Apps (and Argo itself) are expressed as Helm values / manifests inside this repo, so the cluster state is driven entirely from Git.
- **Homelab-friendly hardware** – Low-power mini PCs for the control plane plus a Pi 5 for ARM64 workloads.

## Cluster topology

| Node | Role(s) | Hardware & OS | Notes |
|------|---------|---------------|-------|
| `k1` | Control-plane + worker | [GMKtec G3S Mini PC](https://www.amazon.com/dp/B0FQT44ZCJ?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1), 16GB RAM, 512GB M.2 NVMe SSD, Intel N95, Ubuntu Server 22.04.5 LTS | Runs etcd + system workloads |
| `k2` | Control-plane + worker | Same spec as `k1` | Adds redundancy for etcd/HA + capacity for general workloads |
| `k3` | Control-plane + worker | Same spec as `k1` | Adds redundancy for etcd/HA + capacity for general workloads |
| `k4` | utility worker | Raspberry Pi 5 8 GB, M.2 NVMe SSD, Raspberry Pi OS 64-bit | Handles ARM64 workloads |

K3s runs with embedded etcd on `k1–k3`. 

## GitOps + Argo CD

Argo CD is installed directly in-cluster using the Helm values found at [`k3s/argo/values.yaml`](k3s/argo/values.yaml):

```bash
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f k3s/argo/values.yaml
```

Once Argo is up, install each application defined under `apps/` to roll out individual services (cert-manager, Cloudflare Tunnel, TeslaMate, etc.). See the README.md file in each app for detailed deployment instructions.

## Repository layout

```
.
├── k3s/
│   ├── argo/             # Helm values + bootstrap manifests for Argo CD
│   └── cluster/          # Base manifests, node labels, storage classes, etc.
├── apps/
│   ├── <app>/README.md   # App-specific deploy/runbooks
│   ├── <app>/Chart.yaml  # Argo helm deployment instructions
│   └── <app>/values.yaml # Helm overrides consumed by Argo
├── scripts/              # Helper scripts (maintenance, backups, etc.)
└── docs/                 # Deep dives, troubleshooting notes
```

## Operating the cluster

- **Bootstrap** – Bring up K3s on `k1–k3` (see `k3s/cluster/` for config) and join `k4` as a worker.
- **Install Argo CD** – Use the command above; Argo will continuously reconcile against this repository.
- **Deploy apps** – Add/update values inside `apps/<name>/values.yaml` + README, commit, and let Argo sync.
- **Secrets** – Store sensitive values as Kubernetes secrets generated out-of-band (see each app README for the exact `kubectl create secret …` commands).

## Hardware sourcing, links, and pricing

- Public wishlist (source of pricing data): <https://www.amazon.com/hz/wishlist/ls/2CXIWUZURGSGO>
- All prices reflect Amazon listings captured on **2026-02-23**

| Item (Amazon link) | Purpose / where it’s used | Price (USD, 2026-02-23) |
|--------------------|---------------------------|---------------------------|
| [GMKtec G3S Mini PC](https://www.amazon.com/dp/B0FQT44ZCJ/?ref_=list_c_wl_lv_ov_lig_dp_it) | `k1–k3` control-plane + worker nodes | $199.98 |
| &nbsp;&nbsp;• [Raspberry Pi 5 8 GB board](https://www.amazon.com/dp/B0CK2FCG1K/?ref_=list_c_wl_lv_ov_lig_dp_it) | Base SBC | $134.48 |
| &nbsp;&nbsp;• [iUniker V2 Metal NVMe case + cooler](https://www.amazon.com/dp/B0G4H3Q4CS/?ref_=list_c_wl_lv_ov_lig_dp_it) | Enclosure + active cooling + NVMe mount | $17.99 |
| &nbsp;&nbsp;• [fanxiang S500 Pro 256 GB NVMe SSD](https://www.amazon.com/dp/B0B55SWRCY/?ref_=list_c_wl_lv_ov_lig_dp_it) | Local NVMe storage | $57.99 |
| &nbsp;&nbsp;• [Geekworm X1001 Key-M to PCIe adapter](https://www.amazon.com/dp/B0CPPGGDQT/?ref_=list_c_wl_lv_ov_lig_dp_it) | NVMe carrier + hat | $12.90 |
| [NETGEAR 5-port Gigabit unmanaged switch](https://www.amazon.com/dp/B07PFYM5MZ/?ref_=list_c_wl_lv_ov_lig_dp_it) | Aggregates Pi + mini PCs in the rack | $18.99 |
| [10Gsupxsel Cat6 Ethernet cable (2 ft)](https://www.amazon.com/dp/B0CQXG1WPC/?ref_=list_c_wl_lv_ov_lig_dp_it) | Short patch leads inside the rack | $14.49 |

 
## Resources

- [K3s documentation](https://docs.k3s.io/)
- [Argo CD documentation](https://argo-cd.readthedocs.io/en/stable/)

---

See [LICENSE](LICENSE) for details.
