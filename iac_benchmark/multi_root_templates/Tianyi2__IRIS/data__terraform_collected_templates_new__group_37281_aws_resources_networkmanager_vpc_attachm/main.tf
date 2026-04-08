resource "aws_networkmanager_vpc_attachment" "this" {
  core_network_id = var.core_network_id
  subnet_arns     = var.subnet_arns
  vpc_arn         = var.vpc_arn

  dynamic "options" {
    for_each = var.options != null ? [var.options] : []
    content {
      appliance_mode_support             = options.value.appliance_mode_support
      dns_support                        = options.value.dns_support
      ipv6_support                       = options.value.ipv6_support
      security_group_referencing_support = options.value.security_group_referencing_support
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}