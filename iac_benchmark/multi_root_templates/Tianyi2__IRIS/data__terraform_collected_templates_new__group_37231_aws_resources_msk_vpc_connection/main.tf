resource "aws_msk_vpc_connection" "this" {
  region             = var.region
  authentication     = var.authentication
  client_subnets     = var.client_subnets
  security_groups    = var.security_groups
  target_cluster_arn = var.target_cluster_arn
  vpc_id             = var.vpc_id
  tags               = var.tags

}