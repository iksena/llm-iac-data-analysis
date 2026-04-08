data "aws_ec2_spot_price" "this" {
  region            = var.region
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}