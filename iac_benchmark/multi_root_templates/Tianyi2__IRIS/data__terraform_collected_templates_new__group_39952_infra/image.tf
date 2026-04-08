locals {
  ubuntu_image = {
    file_name = "ubuntu-${var.ubuntu_version}-server-cloudimg-amd64.img",
    url       = "https://cloud-images.ubuntu.com/releases/${var.ubuntu_version}/release/ubuntu-${var.ubuntu_version}-server-cloudimg-amd64.img"
  }
  arch_image = {
    file_name = "Arch-Linux-x86_64-cloudimg-${var.arch_version}.img",
    url       = "https://fastly.mirror.pkgbuild.com/images/v${var.arch_version}/Arch-Linux-x86_64-cloudimg-${var.arch_version}.qcow2"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_secondary_node

  file_name = local.ubuntu_image.file_name
  url       = local.ubuntu_image.url
  overwrite = true
}

resource "proxmox_virtual_environment_download_file" "arch_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_storage_node

  file_name = local.arch_image.file_name
  url       = local.arch_image.url
  overwrite = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_image_storage" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_storage_node

  file_name = local.ubuntu_image.file_name
  url       = local.ubuntu_image.url
  overwrite = true
}
