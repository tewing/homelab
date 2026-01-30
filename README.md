# Homelab

Infrastructure as Code for my personal homelab running Kubernetes on Proxmox.

## Overview

This repository contains Terraform/Terragrunt configurations to provision and manage K3s Kubernetes clusters on a Proxmox virtualization cluster. It supports multiple deployment patterns from simple single-node clusters to advanced multi-nodepool configurations with custom taints and labels.

## Features

- **Automated K3s Deployment** — Spin up production-ready Kubernetes clusters with a single command
- **Multiple Cluster Types** — Support for pure K3s, Rancher-managed, and general-purpose VMs
- **Advanced Node Pools** — Configure multiple agent pools with different resources, labels, and taints
- **Secrets Management** — SOPS + GPG encryption for storing sensitive values in Git
- **Cloud-Init Integration** — Ubuntu templates with QEMU guest agent for seamless provisioning
- **High Availability** — Multi-node control plane support for resilient clusters

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Proxmox Cluster                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   prox1     │  │   prox2     │  │   prox3     │         │
│  │  ┌───────┐  │  │  ┌───────┐  │  │  ┌───────┐  │         │
│  │  │ CP-1  │  │  │  │ CP-2  │  │  │  │ CP-3  │  │         │
│  │  └───────┘  │  │  └───────┘  │  │  └───────┘  │         │
│  │  ┌───────┐  │  │  ┌───────┐  │  │  ┌───────┐  │         │
│  │  │Agent-1│  │  │  │Agent-2│  │  │  │Agent-3│  │         │
│  │  └───────┘  │  │  └───────┘  │  │  └───────┘  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
                    Terraform / Terragrunt
```

## Tech Stack

| Component | Purpose |
|-----------|---------|
| [Proxmox VE](https://www.proxmox.com/) | Hypervisor / Virtualization platform |
| [Terraform](https://www.terraform.io/) | Infrastructure as Code |
| [Terragrunt](https://terragrunt.gruntwork.io/) | Terraform wrapper for DRY configurations |
| [K3s](https://k3s.io/) | Lightweight Kubernetes distribution |
| [SOPS](https://github.com/mozilla/sops) | Secrets encryption |
| [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/) | VM base templates |

## Quick Start

### Prerequisites

- Proxmox VE cluster with API access
- Terraform >= 0.14
- Terragrunt
- SOPS + GPG

### Deployment

```bash
# Clone the repository
git clone --recurse-submodules <repo-url>
cd homelab/proxmox-iac

# Configure your credentials (see detailed docs)
cp clusters/k3s-example clusters/my-cluster
cd clusters/my-cluster

# Edit configuration
vim terragrunt.hcl

# Deploy
terragrunt plan
terragrunt apply
```

See the **[detailed documentation](proxmox-iac/README.md)** for complete setup instructions including:
- GPG key creation
- Ubuntu cloud-init template setup
- SOPS encryption configuration
- Advanced cluster configurations


## Hardware

See my [Amazon shopping list](https://www.amazon.com/hz/wishlist/ls/2CXIWUZURGSGO?ref_=wl_share) for the components used in this homelab.

## Resources

- [Set up a Kubernetes cluster with Proxmox and K3s](https://dev.to/mihailtd/set-up-a-kubernetes-cluster-in-under-5-minutes-with-proxmox-and-k3s-2987) — Original guide that inspired this project

## License

See [LICENSE](LICENSE) for details.
