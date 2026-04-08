resource "aws_s3control_directory_bucket_access_point_scope" "this" {
  account_id = var.account_id
  name       = var.name
  region     = var.region

  dynamic "scope" {
    for_each = var.scope != null ? [var.scope] : []
    content {
      permissions = scope.value.permissions
      prefixes    = scope.value.prefixes
    }
  }
}