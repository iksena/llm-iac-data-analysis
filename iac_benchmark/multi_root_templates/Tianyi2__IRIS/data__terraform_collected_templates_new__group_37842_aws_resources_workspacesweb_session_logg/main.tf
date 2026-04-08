resource "aws_workspacesweb_session_logger" "this" {
  additional_encryption_context = var.additional_encryption_context
  customer_managed_key          = var.customer_managed_key
  display_name                  = var.display_name
  region                        = var.region
  tags                          = var.tags

  dynamic "event_filter" {
    for_each = var.event_filter != null ? [var.event_filter] : []
    content {
      dynamic "all" {
        for_each = lookup(event_filter.value, "all", null) != null ? [event_filter.value.all] : []
        content {}
      }
      include = lookup(event_filter.value, "include", null)
    }
  }

  dynamic "log_configuration" {
    for_each = var.log_configuration != null ? [var.log_configuration] : []
    content {
      dynamic "s3" {
        for_each = lookup(log_configuration.value, "s3", null) != null ? [log_configuration.value.s3] : []
        content {
          bucket           = s3.value.bucket
          folder_structure = s3.value.folder_structure
          log_file_format  = s3.value.log_file_format
          bucket_owner     = lookup(s3.value, "bucket_owner", null)
          key_prefix       = lookup(s3.value, "key_prefix", null)
        }
      }
    }
  }
}