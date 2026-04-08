data "aws_ec2_managed_prefix_list" "this" {
  id   = var.id
  name = var.name

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}