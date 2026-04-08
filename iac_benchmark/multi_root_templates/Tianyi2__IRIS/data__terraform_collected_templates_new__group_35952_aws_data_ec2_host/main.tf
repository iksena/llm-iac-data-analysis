data "aws_ec2_host" "this" {
  region  = var.region
  host_id = var.host_id

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}