resource "aws_quicksight_vpc_connection" "this" {
  vpc_connection_id  = var.vpc_connection_id
  name               = var.name
  role_arn           = var.role_arn
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  aws_account_id     = var.aws_account_id
  dns_resolvers      = var.dns_resolvers
  region             = var.region
  tags               = var.tags

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}