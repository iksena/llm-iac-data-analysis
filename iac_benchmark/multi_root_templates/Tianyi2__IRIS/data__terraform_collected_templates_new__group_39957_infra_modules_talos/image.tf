data "talos_image_factory_extensions_versions" "common" {
  talos_version = var.talos_version
  filters = {
    names = var.extensions
  }
}

data "talos_image_factory_extensions_versions" "gpu" {
  talos_version = var.talos_version
  filters = {
    names = concat(var.extensions, var.gpu_extensions),
  }
}

resource "talos_image_factory_schematic" "common" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.common.extensions_info[*].name
        }
      }
    }
  )
}

resource "talos_image_factory_schematic" "gpu" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.gpu.extensions_info[*].name
        }
      }
    }
  )
}

data "talos_image_factory_urls" "common" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.common.id
  platform      = "nocloud"
}

data "talos_image_factory_urls" "gpu" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.gpu.id
  platform      = "nocloud"
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_common_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  file_name = "talos-${var.talos_version}-nocloud-common-amd64.img"
  url       = data.talos_image_factory_urls.common.urls.iso
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_gpu_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  file_name = "talos-${var.talos_version}-nocloud-gpu-amd64.img"
  url       = data.talos_image_factory_urls.gpu.urls.iso
}
