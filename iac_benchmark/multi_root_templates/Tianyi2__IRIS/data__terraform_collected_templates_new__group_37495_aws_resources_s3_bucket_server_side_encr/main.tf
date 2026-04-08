resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  region                = var.region
  bucket                = var.bucket
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.rule
    content {
      bucket_key_enabled = rule.value.bucket_key_enabled

      dynamic "apply_server_side_encryption_by_default" {
        for_each = rule.value.apply_server_side_encryption_by_default != null ? [rule.value.apply_server_side_encryption_by_default] : []
        content {
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
          kms_master_key_id = apply_server_side_encryption_by_default.value.kms_master_key_id
        }
      }
    }
  }
}