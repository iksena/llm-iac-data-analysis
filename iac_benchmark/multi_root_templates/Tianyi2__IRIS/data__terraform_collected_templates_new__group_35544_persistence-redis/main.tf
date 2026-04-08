locals {
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}
resource "azurerm_managed_disk" "redis_master" {
  count                = var.pv_redis_provider == "azure" && !var.pv_redis_master_disk_source_existing ? 1 : 0
  name                 = "disk-redis-master-${var.kubernetes_tenant_namespace}"
  location             = var.location
  resource_group_name  = var.kubernetes_mc_resource_group_name
  storage_account_type = var.pv_redis_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.pv_redis_storage_gbi
  tags                 = local.tags
}

data "azurerm_managed_disk" "disk_managed_redis_master" {
  count               = var.pv_redis_provider == "azure" && var.pv_redis_master_disk_source_existing ? 1 : 0
  name                = "disk-redis-master-${var.kubernetes_tenant_namespace}"
  resource_group_name = var.kubernetes_mc_resource_group_name
}

resource "azurerm_managed_disk" "redis_replicas" {
  count                = var.pv_redis_provider == "azure" && !var.pv_redis_replica_disk_source_existing ? 1 : 0
  name                 = "disk-redis-replica-${var.kubernetes_tenant_namespace}"
  location             = var.location
  resource_group_name  = var.kubernetes_mc_resource_group_name
  storage_account_type = var.pv_redis_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.pv_redis_storage_gbi
  tags                 = local.tags

  depends_on = [azurerm_managed_disk.redis_master]
}

data "azurerm_managed_disk" "disk_managed_redis_replica" {
  count               = var.pv_redis_provider == "azure" && var.pv_redis_replica_disk_source_existing ? 1 : 0
  name                = "disk-redis-replica-${var.kubernetes_tenant_namespace}"
  resource_group_name = var.kubernetes_mc_resource_group_name
}

resource "kubernetes_persistent_volume" "pv_redis_master" {
  count = var.pv_redis_provider == "azure" ? 1 : 0
  metadata {
    name = "pv-disk-redis-master-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_redis_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_redis_storage_class_name
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = var.pv_redis_master_disk_source_existing ? data.azurerm_managed_disk.disk_managed_redis_master[0].id : azurerm_managed_disk.redis_master[0].id
        disk_name     = var.pv_redis_master_disk_source_existing ? data.azurerm_managed_disk.disk_managed_redis_master[0].name : azurerm_managed_disk.redis_master[0].name
        kind          = "Managed"
      }
    }
  }

  depends_on = [
    azurerm_managed_disk.redis_master,
    data.azurerm_managed_disk.disk_managed_redis_master
  ]
}

resource "kubernetes_persistent_volume" "pv_redis_replicas" {
  count = var.pv_redis_provider == "azure" ? 1 : 0
  metadata {
    name = "pv-disk-redis-replica-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_redis_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_redis_storage_class_name
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = var.pv_redis_replica_disk_source_existing ? data.azurerm_managed_disk.disk_managed_redis_replica[0].id : azurerm_managed_disk.redis_replicas[0].id
        disk_name     = var.pv_redis_replica_disk_source_existing ? data.azurerm_managed_disk.disk_managed_redis_replica[0].name : azurerm_managed_disk.redis_replicas[0].name
        kind          = "Managed"
      }
    }
  }

  depends_on = [
    azurerm_managed_disk.redis_replicas,
    data.azurerm_managed_disk.disk_managed_redis_replica
  ]
}
resource "kubernetes_manifest" "redis_master_longhorn_volume" {
  count = var.pv_redis_provider == "longhorn" ? 1 : 0
  manifest = {
    apiVersion = "longhorn.io/v1beta2"
    kind       = "Volume"
    metadata = {
      name = "disk-redis-master-${var.kubernetes_tenant_namespace}"
      namespace = "longhorn-system"
    }
    spec = {
      size              = tostring(floor(var.pv_redis_storage_gbi * 1024 * 1024 * 1024))
      numberOfReplicas  = 1
      fromBackup        = ""
      frontend         = "blockdev"              
      dataLocality     = "disabled"             
      accessMode       = "rwo"                   
    }
  }
}
resource "kubernetes_persistent_volume" "pv_redis_master_lognhorn" {
  count = var.pv_redis_provider == "longhorn" ? 1 : 0
  metadata {
    name = "pv-disk-redis-master-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_redis_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_redis_storage_class_name
    persistent_volume_source {
      csi {
        driver        = "driver.longhorn.io"
        fs_type       = "ext4"
        volume_handle = var.pv_redis_disk_master_name
      }
    }
  }
  depends_on = [kubernetes_manifest.redis_master_longhorn_volume]
}

resource "kubernetes_manifest" "redis_replica_longhorn_volume" {
  count = var.pv_redis_provider == "longhorn" ? 1 : 0
  manifest = {
    apiVersion = "longhorn.io/v1beta2"
    kind       = "Volume"
    metadata = {
      name = "disk-redis-replica-${var.kubernetes_tenant_namespace}"
      namespace = "longhorn-system"
    }
    spec = {
      size              = tostring(floor(var.pv_redis_storage_gbi * 1024 * 1024 * 1024))
      numberOfReplicas  = 1
      fromBackup        = ""
      frontend         = "blockdev"              
      dataLocality     = "disabled"             
      accessMode       = "rwo" 
    }
  }
}
resource "kubernetes_persistent_volume" "pv_redis_replica_lognhorn" {
  count = var.pv_redis_provider == "longhorn" ? 1 : 0
  metadata {
    name = "pv-disk-redis-replica-${var.kubernetes_tenant_namespace}"
  }
  spec {
    capacity = {
      storage = "${var.pv_redis_storage_gbi}Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pv_redis_storage_class_name
    persistent_volume_source {
      csi {
        driver        = "driver.longhorn.io"
        fs_type       = "ext4"
        volume_handle = var.pv_redis_disk_replica_name
      }
    }
  }
    depends_on = [kubernetes_manifest.redis_replica_longhorn_volume]
}
