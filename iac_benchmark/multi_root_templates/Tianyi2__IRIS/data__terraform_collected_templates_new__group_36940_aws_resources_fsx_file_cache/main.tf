resource "aws_fsx_file_cache" "this" {
  file_cache_type                           = var.file_cache_type
  file_cache_type_version                   = var.file_cache_type_version
  storage_capacity                          = var.storage_capacity
  subnet_ids                                = var.subnet_ids
  region                                    = var.region
  copy_tags_to_data_repository_associations = var.copy_tags_to_data_repository_associations
  kms_key_id                                = var.kms_key_id
  security_group_ids                        = var.security_group_ids
  tags                                      = var.tags

  dynamic "data_repository_association" {
    for_each = var.data_repository_associations
    content {
      file_cache_path                = data_repository_association.value.file_cache_path
      data_repository_path           = data_repository_association.value.data_repository_path
      data_repository_subdirectories = data_repository_association.value.data_repository_subdirectories

      dynamic "nfs" {
        for_each = data_repository_association.value.nfs != null ? [data_repository_association.value.nfs] : []
        content {
          version = nfs.value.version
          dns_ips = nfs.value.dns_ips
        }
      }
    }
  }

  dynamic "lustre_configuration" {
    for_each = var.lustre_configuration != null ? [var.lustre_configuration] : []
    content {
      deployment_type               = lustre_configuration.value.deployment_type
      per_unit_storage_throughput   = lustre_configuration.value.per_unit_storage_throughput
      weekly_maintenance_start_time = lustre_configuration.value.weekly_maintenance_start_time

      dynamic "metadata_configuration" {
        for_each = lustre_configuration.value.metadata_configuration != null ? [lustre_configuration.value.metadata_configuration] : []
        content {
          storage_capacity = metadata_configuration.value.storage_capacity
        }
      }
    }
  }
}