data "aws_ec2_instance_type_offerings" "this" {
  region        = var.region
  location_type = var.location_type

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeout_read
  }
}