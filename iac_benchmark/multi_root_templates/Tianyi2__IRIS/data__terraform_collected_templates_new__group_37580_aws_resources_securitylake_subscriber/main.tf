resource "aws_securitylake_subscriber" "this" {
  region                 = var.region
  access_type            = var.access_type
  subscriber_description = var.subscriber_description
  subscriber_name        = var.subscriber_name

  dynamic "source" {
    for_each = var.source
    content {
      dynamic "aws_log_source_resource" {
        for_each = source.value.aws_log_source_resource != null ? [source.value.aws_log_source_resource] : []
        content {
          source_name    = aws_log_source_resource.value.source_name
          source_version = aws_log_source_resource.value.source_version
        }
      }

      dynamic "custom_log_source_resource" {
        for_each = source.value.custom_log_source_resource != null ? [source.value.custom_log_source_resource] : []
        content {
          source_name    = custom_log_source_resource.value.source_name
          source_version = custom_log_source_resource.value.source_version
        }
      }
    }
  }

  subscriber_identity {
    external_id = var.subscriber_identity.external_id
    principal   = var.subscriber_identity.principal
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}