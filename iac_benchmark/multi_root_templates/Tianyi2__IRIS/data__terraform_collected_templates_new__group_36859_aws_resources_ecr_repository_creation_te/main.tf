resource "aws_ecr_repository_creation_template" "this" {
  region               = var.region
  prefix               = var.prefix
  applied_for          = var.applied_for
  custom_role_arn      = var.custom_role_arn
  description          = var.description
  image_tag_mutability = var.image_tag_mutability
  lifecycle_policy     = var.lifecycle_policy
  repository_policy    = var.repository_policy
  resource_tags        = var.resource_tags

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
}