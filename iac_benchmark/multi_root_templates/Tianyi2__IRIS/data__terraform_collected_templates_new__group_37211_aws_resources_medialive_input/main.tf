resource "aws_medialive_input" "this" {
  name                  = var.name
  input_security_groups = var.input_security_groups
  type                  = var.type

  region   = var.region
  role_arn = var.role_arn
  tags     = var.tags

  dynamic "destinations" {
    for_each = var.destinations != null ? var.destinations : []
    content {
      stream_name = destinations.value.stream_name
    }
  }

  dynamic "input_devices" {
    for_each = var.input_devices != null ? var.input_devices : []
    content {
      id = input_devices.value.id
    }
  }

  dynamic "media_connect_flows" {
    for_each = var.media_connect_flows != null ? var.media_connect_flows : []
    content {
      flow_arn = media_connect_flows.value.flow_arn
    }
  }

  dynamic "sources" {
    for_each = var.sources != null ? var.sources : []
    content {
      password_param = sources.value.password_param
      url            = sources.value.url
      username       = sources.value.username
    }
  }

  dynamic "vpc" {
    for_each = var.vpc != null ? [var.vpc] : []
    content {
      subnet_ids         = vpc.value.subnet_ids
      security_group_ids = vpc.value.security_group_ids
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}