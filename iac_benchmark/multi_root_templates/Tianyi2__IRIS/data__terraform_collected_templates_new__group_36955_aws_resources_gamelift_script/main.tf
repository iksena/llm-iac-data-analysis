resource "aws_gamelift_script" "this" {
  name     = var.name
  region   = var.region
  version  = var.script_version
  tags     = var.tags
  zip_file = var.zip_file

  dynamic "storage_location" {
    for_each = var.storage_location != null ? [var.storage_location] : []
    content {
      bucket         = storage_location.value.bucket
      key            = storage_location.value.key
      role_arn       = storage_location.value.role_arn
      object_version = storage_location.value.object_version
    }
  }
}