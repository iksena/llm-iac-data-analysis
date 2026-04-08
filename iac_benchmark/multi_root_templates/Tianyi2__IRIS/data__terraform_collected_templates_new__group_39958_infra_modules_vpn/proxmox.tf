locals {
  vpn_node = {
    name     = "${var.cluster_name}-${var.environment}-vpn"
    username = "root"
  }
  wireguard_configuration = {
    server = templatefile("${path.module}/templates/wg0.conf.tmpl", {
      server_private_key = wireguard_asymmetric_key.server.private_key,
      client_public_key  = wireguard_asymmetric_key.client.public_key
    })
    client = templatefile("${path.module}/templates/client.conf.tmpl", {
      client_private_key      = wireguard_asymmetric_key.client.private_key,
      server_public_key       = wireguard_asymmetric_key.server.public_key,
      cluster_network_gateway = var.cluster_network_gateway,
      server_ip               = var.dns_name == "" ? var.vm_config.ip : var.dns_name
    })
  }
}



resource "tls_private_key" "root_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "wireguard_asymmetric_key" "server" {
}

resource "wireguard_asymmetric_key" "client" {
}

resource "proxmox_virtual_environment_file" "vpn_user_data" {

  depends_on = [
    tls_private_key.root_ssh
  ]
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<-EOF
      #cloud-config
      hostname: ${local.vpn_node.name}
      users:
        - name: ${local.vpn_node.username}
          groups:
            - sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${tls_private_key.root_ssh.public_key_openssh}
          sudo: ALL=(ALL) NOPASSWD:ALL
          lock_passwd: true
      ssh_pwauth: false
      write_files:
        - content: |
            ${indent(6, local.wireguard_configuration.server)}
          path: /etc/wireguard/wg0.conf
          permissions: '0600'
        - content: |
            ${indent(6, local.wireguard_configuration.client)}
          path: /etc/wireguard/client.conf
          permissions: '0600'
      runcmd:
        - apt update
        - apt upgrade
        - apt install -y qemu-guest-agent net-tools wireguard
        - systemctl enable --now qemu-guest-agent
        - echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf
        - sysctl -p
        - systemctl enable --now wg-quick@wg0
        - echo "done" > /tmp/cloud-config.done
      EOF

    file_name = "vpn-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vpn_node" {
  depends_on = [
    proxmox_virtual_environment_file.vpn_user_data
  ]
  name            = local.vpn_node.name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "ubuntu", "vpn", "terraform"])
  stop_on_destroy = true
  bios            = "ovmf"
  machine         = "q35"
  scsi_hardware   = "virtio-scsi-single"
  operating_system {
    type = "l26"
  }
  cpu {
    type  = "host"
    cores = var.vm_config.cpu
  }
  memory {
    dedicated = var.vm_config.memory
  }
  vga {
    type = "qxl"
  }
  network_device {
    bridge = var.vm_config.network
  }
  tpm_state {
    version = "v2.0"
  }
  efi_disk {
    datastore_id = var.vm_config.efi_disk.datastore_id
    file_format  = var.vm_config.efi_disk.file_format
    type         = var.vm_config.efi_disk.type
  }
  disk {
    datastore_id = var.vm_config.disk.datastore_id
    interface    = var.vm_config.disk.interface
    iothread     = var.vm_config.disk.iothread
    ssd          = var.vm_config.disk.ssd
    discard      = var.vm_config.disk.discard
    size         = var.vm_config.disk.size
    file_format  = var.vm_config.disk.file_format
    file_id      = var.ubuntu_image
  }
  agent {
    enabled = true
    trim    = true
  }
  initialization {
    ip_config {
      ipv4 {
        address = "${var.ip_address}/24"
        gateway = var.cluster_network_gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.vpn_user_data.id
  }
}
