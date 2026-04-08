resource "aws_network_acl" "this" {
  region     = var.region
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      rule_no         = ingress.value.rule_no
      action          = ingress.value.action
      protocol        = ingress.value.protocol
      cidr_block      = ingress.value.cidr_block
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      icmp_type       = ingress.value.icmp_type
      icmp_code       = ingress.value.icmp_code
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      rule_no         = egress.value.rule_no
      action          = egress.value.action
      protocol        = egress.value.protocol
      cidr_block      = egress.value.cidr_block
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      icmp_type       = egress.value.icmp_type
      icmp_code       = egress.value.icmp_code
    }
  }

  tags = var.tags
}