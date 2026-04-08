data "aws_instance" "this" {
  region            = var.region
  instance_id       = var.instance_id
  instance_tags     = var.instance_tags
  get_password_data = var.get_password_data
  get_user_data     = var.get_user_data

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }

  lifecycle {
    precondition {
      condition     = length(var.filter) > 0 || (var.instance_tags != null && length(var.instance_tags) > 0) || (var.instance_id != null && var.instance_id != "")
      error_message = "data_aws_instance: at least one of filter, instance_tags, or instance_id must be specified"
    }
  }
}