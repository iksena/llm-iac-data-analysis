resource "aws_ssmincidents_replication_set" "this" {
  dynamic "regions" {
    for_each = var.regions
    content {
      name        = regions.value.name
      kms_key_arn = regions.value.kms_key_arn
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}