resource "aws_dsql_cluster" "this" {
  deletion_protection_enabled = var.deletion_protection_enabled
  kms_encryption_key          = var.kms_encryption_key
  region                      = var.region
  tags                        = var.tags

  dynamic "multi_region_properties" {
    for_each = var.multi_region_properties != null ? [var.multi_region_properties] : []
    content {
      witness_region = multi_region_properties.value.witness_region
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}