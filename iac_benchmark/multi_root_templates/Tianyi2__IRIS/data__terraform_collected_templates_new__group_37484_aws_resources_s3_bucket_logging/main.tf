resource "aws_s3_bucket_logging" "this" {
  region                = var.region
  bucket                = var.bucket
  expected_bucket_owner = var.expected_bucket_owner
  target_bucket         = var.target_bucket
  target_prefix         = var.target_prefix

  dynamic "target_grant" {
    for_each = var.target_grant
    content {
      permission = target_grant.value.permission

      grantee {
        email_address = target_grant.value.grantee.email_address
        id            = target_grant.value.grantee.id
        type          = target_grant.value.grantee.type
        uri           = target_grant.value.grantee.uri
      }
    }
  }

  dynamic "target_object_key_format" {
    for_each = var.target_object_key_format != null ? [var.target_object_key_format] : []
    content {
      dynamic "partitioned_prefix" {
        for_each = target_object_key_format.value.partitioned_prefix != null ? [target_object_key_format.value.partitioned_prefix] : []
        content {
          partition_date_source = partitioned_prefix.value.partition_date_source
        }
      }

      dynamic "simple_prefix" {
        for_each = target_object_key_format.value.simple_prefix != null ? [target_object_key_format.value.simple_prefix] : []
        content {}
      }
    }
  }
}