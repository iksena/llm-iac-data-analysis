locals {
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}
resource "azurerm_managed_disk" "postgres_master" {
  count                = var.pv_postgres_provider == "azure" && !var.pv_postgres_disk_source_existing ? 1 : 0
  name                 = "disk-postgres-${var.kubernetes_tenant_namespace}"
  location             = var.location
  resource_group_name  = var.kubernetes_mc_resource_group_name
  storage_account_type = var.pv_postgres_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.pv_postgres_storage_gbi
  tags                 = local.tags
}

data "azurerm_managed_disk" "disk_managed_postgres" {
  count               = var.pv_postgres_provider == "azure" && var.pv_postgres_disk_source_existing ? 1 : 0
  name                = "disk-postgres-${var.kubernetes_tenant_namespace}"
  resource_group_name = var.kubernetes_mc_resource_group_name
}

resource "kubernetes_persistent_volume" "pv_postgres_master" {
  count = var.pv_postgres_provider == "azure" ? 1 : 0
  metadata {
    name = "pv-disk-postgres-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_postgres_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_postgres_storage_class_name
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = var.pv_postgres_disk_source_existing ? data.azurerm_managed_disk.disk_managed_postgres.0.id : azurerm_managed_disk.postgres_master.0.id
        disk_name     = var.pv_postgres_disk_source_existing ? data.azurerm_managed_disk.disk_managed_postgres.0.name : azurerm_managed_disk.postgres_master.0.name
        kind          = "Managed"
      }
    }
  }

  depends_on = [
    azurerm_managed_disk.postgres_master,
    data.azurerm_managed_disk.disk_managed_postgres
  ]
}
resource "kubernetes_manifest" "postgres_longhorn_volume" {
  count = var.pv_postgres_provider == "longhorn" ? 1 : 0
  manifest = {
    apiVersion = "longhorn.io/v1beta2"
    kind       = "Volume"
    metadata = {
      name      = "disk-postgres-${var.kubernetes_tenant_namespace}"
      namespace = "longhorn-system"
    }
    spec = {
      size             = tostring(floor(var.pv_postgres_storage_gbi * 1024 * 1024 * 1024))
      numberOfReplicas = 1
      fromBackup       = ""
      frontend         = "blockdev"
      dataLocality     = "disabled"
      accessMode       = "rwo"
    }
  }
}
resource "kubernetes_persistent_volume" "pv_postgres_master_lognhorn" {
  count = var.pv_postgres_provider == "longhorn" ? 1 : 0
  metadata {
    name = "pv-disk-postgres-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_postgres_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_postgres_storage_class_name
    persistent_volume_source {
      csi {
        driver        = "driver.longhorn.io"
        fs_type       = "ext4"
        volume_handle = var.pv_postgres_disk_master_name
      }
    }
  }
  depends_on = [kubernetes_manifest.postgres_longhorn_volume]
}
