data "aws_ssm_instances" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}