data "aws_vpc_security_group_rule" "this" {
  region                 = var.region
  security_group_rule_id = var.security_group_rule_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}