resource "aws_security_group_rule" "this" {
  from_port         = var.from_port
  protocol          = var.protocol
  security_group_id = var.security_group_id
  to_port           = var.to_port
  type              = var.type

  region                   = var.region
  cidr_blocks              = var.cidr_blocks
  description              = var.description
  ipv6_cidr_blocks         = var.ipv6_cidr_blocks
  prefix_list_ids          = var.prefix_list_ids
  self                     = var.self
  source_security_group_id = var.source_security_group_id

  timeouts {
    create = var.timeout_create
  }
}