resource "aws_default_security_group" "this" {
  region = var.region
  vpc_id = var.vpc_id
  tags   = var.tags

  dynamic "egress" {
    for_each = var.egress
    content {
      cidr_blocks      = egress.value.cidr_blocks
      description      = egress.value.description
      from_port        = egress.value.from_port
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      prefix_list_ids  = egress.value.prefix_list_ids
      protocol         = egress.value.protocol
      security_groups  = egress.value.security_groups
      self             = egress.value.self
      to_port          = egress.value.to_port
    }
  }

  dynamic "ingress" {
    for_each = var.ingress
    content {
      cidr_blocks      = ingress.value.cidr_blocks
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      protocol         = ingress.value.protocol
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
      to_port          = ingress.value.to_port
    }
  }
}