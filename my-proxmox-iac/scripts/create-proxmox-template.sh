#!/bin/bash

VMID=$(pvesh get /cluster/nextid)

cd /tmp
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
virt-customize -a /tmp/focal-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a /tmp/focal-server-cloudimg-amd64.img --run-command "echo -n > /etc/machine-id"
touch /etc/pve/nodes/$(hostname)/qemu-server/$VMID.conf
qm importdisk $VMID /tmp/focal-server-cloudimg-amd64.img local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9991-disk-0
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1
qm set $VMID --name ubuntu-ci-template
qm template $VMID