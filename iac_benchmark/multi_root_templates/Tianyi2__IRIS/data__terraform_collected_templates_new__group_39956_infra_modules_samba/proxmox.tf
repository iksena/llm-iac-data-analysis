locals {
  samba_node = {
    name     = "${var.cluster_name}-${var.environment}-samba"
    username = "root"
  }

  smb_conf = templatefile("${path.module}/templates/smb.conf.tmpl", {
    guest_user        = var.guest_user
    admin_user        = var.admin_user
    storage_path      = var.storage_path
    samba_directories = var.samba_directories
  })
  samba_share_paths = join(" ", [for share in var.samba_directories : "${trimsuffix(var.storage_path, "/")}/${share.name}"])
}

resource "tls_private_key" "root_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "admin_password" {
  length  = 24
  special = false
}

resource "proxmox_virtual_environment_file" "samba_user_data" {

  depends_on = [
    tls_private_key.root_ssh
  ]
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<-EOF
      #cloud-config
      hostname: ${local.samba_node.name}
      users:
        - name: ${local.samba_node.username}
          groups:
            - sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${tls_private_key.root_ssh.public_key_openssh}
          sudo: ALL=(ALL) NOPASSWD:ALL
          lock_passwd: true
        - name: ${var.guest_user}
          shell: /usr/sbin/nologin
          lock_passwd: true
      ssh_pwauth: false
      write_files:
        - content: |
            ${indent(6, local.smb_conf)}
          path: /etc/samba/smb.conf
          permissions: '0644'
        - content: |
            <?xml version="1.0" standalone='no'?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
            <service-group>
              <name replace-wildcards="yes">%h</name>
              <service>
                <type>_smb._tcp</type>
                <port>445</port>
              </service>
            </service-group>
          path: /etc/avahi/services/samba.service
          permissions: '0644'
      runcmd:
        - mkfs.ext4 /dev/sdb
        - mkdir -p ${var.storage_path}
        - echo "/dev/sdb ${var.storage_path} ext4 defaults 0 0" >> /etc/fstab
        - mount -a
        - mkdir -p ${local.samba_share_paths}
        - systemctl daemon-reload
        - printf 'Dpkg::Options {\n  "--force-confdef";\n  "--force-confold";\n};\n' > /etc/apt/apt.conf.d/90force-conf
        - DEBIAN_FRONTEND=noninteractive apt-get update
        - DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
        - DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-guest-agent samba avahi-daemon
        - groupadd -f ${var.admin_user}
        - useradd -M -s /usr/sbin/nologin -g ${var.admin_user} ${var.admin_user}
        - |
          USER="${var.admin_user}"
          PASS="${random_password.admin_password.result}"
          if ! pdbedit --user="$USER" >/dev/null 2>&1; then
            printf '%s\n%s\n' "$PASS" "$PASS" | smbpasswd -s -a "$USER"
          fi
        - chown -R ${var.admin_user}:${var.admin_user} ${var.storage_path}
        - chmod -R 0775 ${var.storage_path}
        - systemctl enable --now qemu-guest-agent
        - systemctl enable --now smbd
        - systemctl enable --now avahi-daemon
        - echo "done" > /tmp/cloud-config.done
      EOF

    file_name = "samba-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "samba_node" {
  depends_on = [
    proxmox_virtual_environment_file.samba_user_data
  ]

  name            = local.samba_node.name
  node_name       = var.proxmox_node_name
  tags            = sort([var.cluster_name, var.environment, "ubuntu", "samba", "terraform"])
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

  disk {
    datastore_id = var.samba_data_disk.datastore_id
    interface    = var.samba_data_disk.interface
    ssd          = var.samba_data_disk.ssd
    discard      = var.samba_data_disk.discard
    size         = var.samba_data_disk.size
    file_format  = var.samba_data_disk.file_format
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

    user_data_file_id = proxmox_virtual_environment_file.samba_user_data.id
  }
}
