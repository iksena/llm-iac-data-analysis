resource "aws_redshift_endpoint_access" "this" {
  region                 = var.region
  cluster_identifier     = var.cluster_identifier
  endpoint_name          = var.endpoint_name
  resource_owner         = var.resource_owner
  subnet_group_name      = var.subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
}