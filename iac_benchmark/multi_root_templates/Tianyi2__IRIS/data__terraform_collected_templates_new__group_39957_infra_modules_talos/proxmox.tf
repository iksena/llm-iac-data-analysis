locals {
  control_nodes = [
    for i in range(var.vm_config["control"].count) : {
      name    = "${var.cluster_name}-${var.environment}-ctrl-${i + 1}"
      address = var.control_node_ips[i]
    }
  ]
  worker_nodes = [
    for i in range(var.vm_config["worker"].count) : {
      name    = "${var.cluster_name}-${var.environment}-worker-${i + 1}"
      address = var.worker_node_ips[i]
    }
  ]
  gpu_node = {
    name    = "${var.cluster_name}-${var.environment}-worker-gpu"
    address = var.gpu_node_ip
  }
}


resource "proxmox_virtual_environment_vm" "talos_control_plane" {
  count           = var.vm_config["control"].count
  name            = local.control_nodes[count.index].name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "talos", "control", "terraform"])
  stop_on_destroy = true
  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  operating_system {
    type = "l26"
  }
  cpu {
    type  = "host"
    cores = var.vm_config["control"].cpu
  }
  memory {
    dedicated = var.vm_config["control"].memory
  }
  vga {
    type = "qxl"
  }
  network_device {
    bridge = var.vm_config["control"].network
  }
  tpm_state {
    version = "v2.0"
  }
  efi_disk {
    datastore_id = var.vm_config["control"].efi_disk.datastore_id
    file_format  = var.vm_config["control"].efi_disk.file_format
    type         = var.vm_config["control"].efi_disk.type
  }
  disk {
    datastore_id = var.vm_config["control"].disk.datastore_id
    interface    = var.vm_config["control"].disk.interface
    iothread     = var.vm_config["control"].disk.iothread
    ssd          = var.vm_config["control"].disk.ssd
    discard      = var.vm_config["control"].disk.discard
    size         = var.vm_config["control"].disk.size
    file_format  = var.vm_config["control"].disk.file_format
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_common_image.id
  }
  agent {
    enabled = true
    trim    = true
  }
  initialization {
    ip_config {
      ipv4 {
        address = "${local.control_nodes[count.index].address}/24"
        gateway = var.cluster_network_gateway
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "talos_worker" {
  count           = var.vm_config["worker"].count
  name            = local.worker_nodes[count.index].name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "talos", "worker", "terraform"])
  stop_on_destroy = true
  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  operating_system {
    type = "l26"
  }
  cpu {
    type  = "host"
    cores = var.vm_config["worker"].cpu
  }
  memory {
    dedicated = var.vm_config["worker"].memory
  }
  vga {
    type = "qxl"
  }
  network_device {
    bridge = var.vm_config["worker"].network
  }
  tpm_state {
    version = "v2.0"
  }
  efi_disk {
    datastore_id = var.vm_config["worker"].efi_disk.datastore_id
    file_format  = var.vm_config["worker"].efi_disk.file_format
    type         = var.vm_config["worker"].efi_disk.type
  }
  disk {
    datastore_id = var.vm_config["worker"].disk.datastore_id
    interface    = var.vm_config["worker"].disk.interface
    iothread     = var.vm_config["worker"].disk.iothread
    ssd          = var.vm_config["worker"].disk.ssd
    discard      = var.vm_config["worker"].disk.discard
    size         = var.vm_config["worker"].disk.size
    file_format  = var.vm_config["worker"].disk.file_format
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_common_image.id
  }
  agent {
    enabled = true
    trim    = true
  }
  initialization {
    ip_config {
      ipv4 {
        address = "${local.worker_nodes[count.index].address}/24"
        gateway = var.cluster_network_gateway
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "talos_gpu" {
  count           = var.gpu_vm_config.enabled ? 1 : 0
  name            = local.gpu_node.name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "talos", "worker", "gpu", "terraform"])
  stop_on_destroy = true
  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  operating_system {
    type = "l26"
  }
  cpu {
    type  = "host"
    cores = var.gpu_vm_config.cpu
  }
  memory {
    dedicated = var.gpu_vm_config.memory
  }
  vga {
    type = "qxl"
  }
  network_device {
    bridge = var.gpu_vm_config.network
  }
  tpm_state {
    version = "v2.0"
  }
  efi_disk {
    datastore_id = var.gpu_vm_config.efi_disk.datastore_id
    file_format  = var.gpu_vm_config.efi_disk.file_format
    type         = var.gpu_vm_config.efi_disk.type
  }
  hostpci {
    id     = var.gpu_vm_config.hostpci.id
    device = var.gpu_vm_config.hostpci.device
    pcie   = var.gpu_vm_config.hostpci.pcie
  }
  disk {
    datastore_id = var.gpu_vm_config.disk.datastore_id
    interface    = var.gpu_vm_config.disk.interface
    iothread     = var.gpu_vm_config.disk.iothread
    ssd          = var.gpu_vm_config.disk.ssd
    discard      = var.gpu_vm_config.disk.discard
    size         = var.gpu_vm_config.disk.size
    file_format  = var.gpu_vm_config.disk.file_format
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_gpu_image.id
  }
  agent {
    enabled = true
    trim    = true
  }
  initialization {
    ip_config {
      ipv4 {
        address = "${local.gpu_node.address}/24"
        gateway = var.cluster_network_gateway
      }
    }
  }
}
