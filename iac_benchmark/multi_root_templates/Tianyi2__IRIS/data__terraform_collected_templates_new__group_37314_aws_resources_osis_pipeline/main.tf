resource "aws_osis_pipeline" "this" {
  pipeline_name               = var.pipeline_name
  pipeline_configuration_body = var.pipeline_configuration_body
  max_units                   = var.max_units
  min_units                   = var.min_units
  region                      = var.region
  tags                        = var.tags

  dynamic "buffer_options" {
    for_each = var.buffer_options != null ? [var.buffer_options] : []
    content {
      persistent_buffer_enabled = buffer_options.value.persistent_buffer_enabled
    }
  }

  dynamic "encryption_at_rest_options" {
    for_each = var.encryption_at_rest_options != null ? [var.encryption_at_rest_options] : []
    content {
      kms_key_arn = encryption_at_rest_options.value.kms_key_arn
    }
  }

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options != null ? [var.log_publishing_options] : []
    content {
      is_logging_enabled = log_publishing_options.value.is_logging_enabled

      dynamic "cloudwatch_log_destination" {
        for_each = log_publishing_options.value.cloudwatch_log_destination != null ? [log_publishing_options.value.cloudwatch_log_destination] : []
        content {
          log_group = cloudwatch_log_destination.value.log_group
        }
      }
    }
  }

  dynamic "vpc_options" {
    for_each = var.vpc_options != null ? [var.vpc_options] : []
    content {
      subnet_ids              = vpc_options.value.subnet_ids
      security_group_ids      = vpc_options.value.security_group_ids
      vpc_endpoint_management = vpc_options.value.vpc_endpoint_management
    }
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}