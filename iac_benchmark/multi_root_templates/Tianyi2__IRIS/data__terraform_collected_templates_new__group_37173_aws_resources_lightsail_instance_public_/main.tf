resource "aws_lightsail_instance_public_ports" "this" {
  instance_name = var.instance_name
  region        = var.region

  dynamic "port_info" {
    for_each = var.port_info
    content {
      from_port         = port_info.value.from_port
      protocol          = port_info.value.protocol
      to_port           = port_info.value.to_port
      cidr_list_aliases = port_info.value.cidr_list_aliases
      cidrs             = port_info.value.cidrs
      ipv6_cidrs        = port_info.value.ipv6_cidrs
    }
  }
}