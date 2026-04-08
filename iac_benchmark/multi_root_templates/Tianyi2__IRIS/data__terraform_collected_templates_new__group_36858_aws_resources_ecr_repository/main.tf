resource "aws_ecr_repository" "this" {
  region               = var.region
  name                 = var.name
  force_delete         = var.force_delete
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      encryption_type = encryption_configuration.value.encryption_type
      kms_key         = encryption_configuration.value.kms_key
    }
  }

  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = var.image_tag_mutability_exclusion_filter != null ? var.image_tag_mutability_exclusion_filter : []
    content {
      filter      = image_tag_mutability_exclusion_filter.value.filter
      filter_type = image_tag_mutability_exclusion_filter.value.filter_type
    }
  }

  dynamic "image_scanning_configuration" {
    for_each = var.image_scanning_configuration != null ? [var.image_scanning_configuration] : []
    content {
      scan_on_push = image_scanning_configuration.value.scan_on_push
    }
  }

  timeouts {
    delete = var.timeouts != null ? var.timeouts.delete : null
  }
}