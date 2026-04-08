resource "aws_directory_service_directory" "this" {
  name                                 = var.name
  password                             = var.password
  size                                 = var.size
  alias                                = var.alias
  description                          = var.description
  desired_number_of_domain_controllers = var.desired_number_of_domain_controllers
  short_name                           = var.short_name
  enable_sso                           = var.enable_sso
  type                                 = var.type
  edition                              = var.edition
  tags                                 = var.tags

  dynamic "vpc_settings" {
    for_each = var.vpc_settings != null ? [var.vpc_settings] : []
    content {
      subnet_ids = vpc_settings.value.subnet_ids
      vpc_id     = vpc_settings.value.vpc_id
    }
  }

  dynamic "connect_settings" {
    for_each = var.connect_settings != null ? [var.connect_settings] : []
    content {
      customer_username = connect_settings.value.customer_username
      customer_dns_ips  = connect_settings.value.customer_dns_ips
      subnet_ids        = connect_settings.value.subnet_ids
      vpc_id            = connect_settings.value.vpc_id
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}