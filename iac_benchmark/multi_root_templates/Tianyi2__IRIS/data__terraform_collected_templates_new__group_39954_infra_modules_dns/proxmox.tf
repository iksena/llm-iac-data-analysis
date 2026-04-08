locals {
  dns_node = {
    name     = "${var.cluster_name}-${var.environment}-dns"
    username = "root"
  }

  aws_credentials = templatefile("${path.module}/templates/aws/credentials.tmpl", {
    access_key_id     = var.aws_iam_credentials.access_key_id
    secret_access_key = var.aws_iam_credentials.secret_access_key
  })

  aws_config = templatefile("${path.module}/templates/aws/config.tmpl", {
    aws_region = var.aws_region
  })

  coredns = {
    version = "1.12.0"
    service = templatefile("${path.module}/templates/coredns/coredns.service.tmpl", {})
    config = templatefile("${path.module}/templates/coredns/Corefile.tmpl", {
      base_domain         = var.base_domain
      aws_route53_zone_id = var.aws_route53_zone_id
      k8s_lb_ip           = var.k8s_lb_ip
      subzone_records     = var.subzone_records
    })
  }
  resolved_configuration = templatefile("${path.module}/templates/resolved.conf.tmpl", {})
}

resource "tls_private_key" "root_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_virtual_environment_file" "dns_user_data" {
  depends_on = [
    tls_private_key.root_ssh
  ]
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<-EOF
      #cloud-config
      hostname: ${local.dns_node.name}
      users:
        - name: ${local.dns_node.username}
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
            ${indent(6, local.coredns.config)}
          path: /etc/coredns/Corefile
          permissions: '0644'
        - content: |
            ${indent(6, local.coredns.service)}
          path: /etc/systemd/system/coredns.service
          permissions: '0644'
        - content: |
            ${indent(6, local.resolved_configuration)}
          path: /etc/systemd/resolved.conf
          permissions: '0644'
        - content: |
            ${indent(6, local.aws_config)}
          path: /root/.aws/config
          permissions: '0644'
        - content: |
            ${indent(6, local.aws_credentials)}
          path: /root/.aws/credentials
          permissions: '0644'
      runcmd:
        - apt update
        - apt upgrade
        - apt install -y qemu-guest-agent
        - cd /tmp
        - wget https://github.com/coredns/coredns/releases/download/v${local.coredns.version}/coredns_${local.coredns.version}_linux_amd64.tgz
        - tar -xzvf coredns_${local.coredns.version}_linux_amd64.tgz
        - mv coredns /usr/bin/
        - cd --
        - systemctl daemon-reload
        - systemctl enable --now qemu-guest-agent
        - systemctl restart systemd-resolved
        - systemctl enable --now coredns
        - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "dns-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "dns_node" {
  depends_on = [
    proxmox_virtual_environment_file.dns_user_data
  ]
  name            = local.dns_node.name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "ubuntu", "dns", "terraform"])
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

    user_data_file_id = proxmox_virtual_environment_file.dns_user_data.id
  }
}
