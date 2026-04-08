
locals {
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}
resource "azurerm_managed_disk" "minio_master" {
  count                = var.pv_minio_provider == "azure" && var.pv_minio_disk_source_existing ? 0 : 1
  name                 = "disk-minio-${var.kubernetes_tenant_namespace}"
  location             = var.location
  resource_group_name  = var.kubernetes_mc_resource_group_name
  storage_account_type = var.pv_minio_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.pv_minio_storage_gbi
  tags                 = local.tags
}

data "azurerm_managed_disk" "disk_managed_minio" {
  count               = var.pv_minio_provider == "azure" && var.pv_minio_disk_source_existing ? 1 : 0
  name                = "disk-minio-${var.kubernetes_tenant_namespace}"
  resource_group_name = var.kubernetes_mc_resource_group_name
}

resource "kubernetes_persistent_volume" "pv_minio_master" {
  count = var.pv_minio_provider == "azure" ? 1 : 0
  metadata {
    name = "pv-disk-minio-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_minio_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_minio_storage_class_name
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = var.pv_minio_disk_source_existing ? data.azurerm_managed_disk.disk_managed_minio.0.id : azurerm_managed_disk.minio_master.0.id
        disk_name     = var.pv_minio_disk_source_existing ? data.azurerm_managed_disk.disk_managed_minio.0.name : azurerm_managed_disk.minio_master.0.name
        kind          = "Managed"
      }
    }
  }

  depends_on = [
    azurerm_managed_disk.minio_master,
    data.azurerm_managed_disk.disk_managed_minio
  ]
}


resource "kubernetes_persistent_volume" "pv_minio_master_lognhorn" {
  count = var.pv_minio_provider == "longhorn" ? 1 : 0
  metadata {
    name = "pv-disk-minio-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_minio_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_minio_storage_class_name
    persistent_volume_source {
      csi {
        driver        = "driver.longhorn.io"
        fs_type       = "ext4"
        volume_handle = var.pv_minio_disk_master_name
      }
    }
  }
}