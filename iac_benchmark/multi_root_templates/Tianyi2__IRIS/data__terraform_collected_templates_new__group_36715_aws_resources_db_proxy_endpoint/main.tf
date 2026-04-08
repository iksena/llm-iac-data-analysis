resource "aws_db_proxy_endpoint" "this" {
  db_proxy_endpoint_name = var.db_proxy_endpoint_name
  db_proxy_name          = var.db_proxy_name
  vpc_subnet_ids         = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids
  target_role            = var.target_role
  tags                   = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}