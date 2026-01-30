terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.prox_url
  pm_api_token_id     = var.prox_api_id
  pm_api_token_secret = var.prox_api_token
  pm_tls_insecure     = true # By default Proxmox Virtual Environment uses self-signed certificates.
  pm_debug            = true
}

resource "random_shuffle" "prox_nodes" {
  input        = var.prox_nodes
  result_count = var.result_count

  keepers = {
    cluster_name = "${var.cluster_name}"
  }
}

resource "proxmox_vm_qemu" "controlplane_first" {
  name        = "${random_shuffle.prox_nodes.keepers.cluster_name}-cp-1"
  target_node = random_shuffle.prox_nodes.result[0]
  ipconfig0   = "ip=dhcp"
  agent       = var.qemu_agent
  clone       = var.clone_template
  bios        = var.bios
  scsihw      = var.scsihw

  # Wait for guest agent to report IP
  define_connection_info = true
  agent_timeout          = 120

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  memory     = var.cp_memory
  os_type    = var.os_type
  nameserver = var.dns_servers
  sshkeys    = var.ssh_key_public
  ciuser     = var.ssh_user
  cipassword = var.ssh_password

  cpu {
    cores = var.cp_cores
  }

  disk {
    slot    = "scsi0"
    type    = var.disk_type
    storage = var.storage_pool
    size    = var.cp_disk_size
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_key_private
    host        = self.default_ipv4_address
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "scripts/controlplane-first.sh"
    destination = "/tmp/controlplane-first.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/controlplane-first.sh",
      "sudo /tmp/controlplane-first.sh \"${var.controlplane_count}\" \"${self.name}\" \"${var.cluster_secret}\""
    ]
  }
}

resource "proxmox_vm_qemu" "controlplane_all" {
  count       = var.controlplane_count - 1
  name        = join("", [random_shuffle.prox_nodes.keepers.cluster_name, "-cp-", count.index + 2])
  target_node = random_shuffle.prox_nodes.result[count.index + 1]
  ipconfig0   = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  agent  = var.qemu_agent
  clone  = var.clone_template
  bios   = var.bios
  scsihw = var.scsihw

  # Wait for guest agent to report IP
  define_connection_info = true
  agent_timeout          = 120

  memory     = var.cp_memory
  os_type    = var.os_type
  nameserver = var.dns_servers
  sshkeys    = var.ssh_key_public
  ciuser     = var.ssh_user
  cipassword = var.ssh_password

  cpu {
    cores = var.cp_cores
  }

  disk {
    slot    = "scsi0"
    type    = var.disk_type
    storage = var.storage_pool
    size    = var.cp_disk_size
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_key_private
    host        = self.default_ipv4_address
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "scripts/controlplane-all.sh"
    destination = "/tmp/controlplane-all.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/controlplane-all.sh",
      "sudo /tmp/controlplane-all.sh \"${count.index}\" \"${self.name}\" \"${var.cluster_secret}\" \"${proxmox_vm_qemu.controlplane_first.default_ipv4_address}\""
    ]
  }

  depends_on = [
    proxmox_vm_qemu.controlplane_first,
  ]
}

resource "proxmox_vm_qemu" "agents" {
  count       = var.agent_count
  name        = join("", [random_shuffle.prox_nodes.keepers.cluster_name, "-agent-", count.index + 1])
  target_node = random_shuffle.prox_nodes.result[var.controlplane_count + count.index]
  ipconfig0   = "ip=dhcp"
  agent       = var.qemu_agent
  clone       = var.clone_template
  bios        = var.bios
  scsihw      = var.scsihw

  # Wait for guest agent to report IP
  define_connection_info = true
  agent_timeout          = 120

  memory     = var.agent_memory
  os_type    = var.os_type
  nameserver = var.dns_servers
  sshkeys    = var.ssh_key_public
  ciuser     = var.ssh_user
  cipassword = var.ssh_password

  cpu {
    cores = var.agent_cores
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  disk {
    slot    = "scsi0"
    type    = var.disk_type
    storage = var.storage_pool
    size    = var.agent_disk_size
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_key_private
    host        = self.default_ipv4_address
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "scripts/agent.sh"
    destination = "/tmp/agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/agent.sh",
      "sudo /tmp/agent.sh \"${self.name}\" \"${var.cluster_secret}\" \"${proxmox_vm_qemu.controlplane_first.default_ipv4_address}\""
    ]
  }

  depends_on = [
    proxmox_vm_qemu.controlplane_first,
    proxmox_vm_qemu.controlplane_all,
  ]
}
