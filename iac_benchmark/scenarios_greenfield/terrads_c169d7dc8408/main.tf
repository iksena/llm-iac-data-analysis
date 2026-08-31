data "aws_availability_zones" "this" {}

locals {
  key_pair_name      = coalesce(var.key_pair_name, "${var.name}-key")
  availability_zones = data.aws_availability_zones.this.names
}

resource "aws_lightsail_instance" "this" {
  count = var.create ? var.number_of_instances : 0

  name              = var.number_of_instances == 1 ? var.name : format("%s-%02d", var.name, (count.index + 1))
  availability_zone = coalesce(var.availability_zone, local.availability_zones[count.index % length(local.availability_zones)])
  ip_address_type   = var.ip_address_type
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = local.key_pair_name
  user_data         = var.user_data
  tags              = var.tags

  dynamic "add_on" {
    for_each = var.add_ons == {} ? [] : [1]

    content {
      type          = try(var.add_ons.type, "AutoSnapshot")
      snapshot_time = try(var.add_ons.snapshot_time, "03:00")
      status        = try(var.add_ons.status, "Disabled")
    }
  }

  depends_on = [aws_lightsail_key_pair.this]
}

resource "aws_lightsail_instance_public_ports" "this" {
  count         = var.create ? var.number_of_instances : 0
  instance_name = try(aws_lightsail_instance.this[count.index].name, "")

  dynamic "port_info" {
    for_each = var.port_info

    content {
      protocol          = try(port_info.value.protocol, "tcp")
      from_port         = try(port_info.value.from_port, port_info.value.port, "443")
      to_port           = try(port_info.value.to_port, port_info.value.port, "443")
      cidrs             = try(port_info.value.cidrs, ["0.0.0.0/0"])
      ipv6_cidrs        = try(port_info.value.ipv6_cidrs, null)
      cidr_list_aliases = try(port_info.value.cidr_list_aliases, null)
    }
  }
}

resource "aws_lightsail_static_ip_attachment" "this" {
  count          = var.create && var.create_static_ip ? var.number_of_instances : 0
  static_ip_name = aws_lightsail_static_ip.this[count.index].id
  instance_name  = aws_lightsail_instance.this[count.index].id
}

resource "aws_lightsail_static_ip" "this" {
  count = var.create && var.create_static_ip ? var.number_of_instances : 0
  name  = var.number_of_instances == 1 ? "${var.name}-ip" : format("%s-ip-%02d", var.name, (count.index + 1))
}

resource "aws_lightsail_key_pair" "this" {
  count      = var.create && var.use_default_key_pair == false ? 1 : 0
  name       = local.key_pair_name
  public_key = var.public_key
}
