resource "aws_athena_database" "this" {
  region                = var.region
  bucket                = var.bucket
  name                  = var.name
  comment               = var.comment
  expected_bucket_owner = var.expected_bucket_owner
  force_destroy         = var.force_destroy
  properties            = var.properties
  workgroup             = var.workgroup

  dynamic "acl_configuration" {
    for_each = var.acl_configuration != null ? [var.acl_configuration] : []
    content {
      s3_acl_option = acl_configuration.value.s3_acl_option
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      encryption_option = encryption_configuration.value.encryption_option
      kms_key           = encryption_configuration.value.kms_key
    }
  }
}