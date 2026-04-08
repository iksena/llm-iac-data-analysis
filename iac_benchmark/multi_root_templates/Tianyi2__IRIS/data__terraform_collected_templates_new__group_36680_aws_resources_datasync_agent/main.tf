resource "aws_datasync_agent" "this" {
  region                = var.region
  name                  = var.name
  activation_key        = var.activation_key
  ip_address            = var.ip_address
  private_link_endpoint = var.private_link_endpoint
  security_group_arns   = var.security_group_arns
  subnet_arns           = var.subnet_arns
  tags                  = var.tags
  vpc_endpoint_id       = var.vpc_endpoint_id

  timeouts {
    create = var.timeouts_create
  }
}