resource "aws_security_group" "main" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.name_prefix}-"

  description = "Inbound and outbound traffic to the documentdb cluster"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    var.security_group_tags,
    var.tags,
    {
      Name = var.name_prefix
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "cidr_blocks" {
  for_each = length(var.cidr_blocks) > 0 && var.create_security_group ? toset(var.cidr_blocks) : []

  description       = "Ingress for cidr blocks"
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main[0].id
  cidr_ipv4         = each.value

  tags = merge(
    var.tags,
    var.security_group_tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "prefix_lists" {
  for_each = length(var.prefix_list_ids) > 0 && var.create_security_group ? toset(var.prefix_list_ids) : []

  description       = "Ingress for prefix lists"
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main[0].id
  prefix_list_id    = each.value

  tags = merge(
    var.tags,
    var.security_group_tags
  )
}

resource "aws_vpc_security_group_egress_rule" "default_egress" {
  count = var.create_security_group ? 1 : 0

  description       = "Default egress for documentdb cluster"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.main[0].id

  tags = merge(
    var.tags,
    var.security_group_tags
  )
}
