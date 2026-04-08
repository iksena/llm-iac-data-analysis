locals {
  name_validation = var.name != null && var.name_prefix != null ? tobool("Both name and name_prefix cannot be specified") : true
}

resource "aws_secretsmanager_secret" "this" {
  region                         = var.region
  description                    = var.description
  kms_key_id                     = var.kms_key_id
  name_prefix                    = var.name_prefix
  name                           = var.name
  policy                         = var.policy
  recovery_window_in_days        = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  tags                           = var.tags

  dynamic "replica" {
    for_each = var.replica
    content {
      kms_key_id = replica.value.kms_key_id
      region     = replica.value.region
    }
  }
}