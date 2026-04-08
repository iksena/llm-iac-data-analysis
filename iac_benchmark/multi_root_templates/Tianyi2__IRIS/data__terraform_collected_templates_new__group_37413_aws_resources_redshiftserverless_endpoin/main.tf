resource "aws_redshiftserverless_endpoint_access" "this" {
  endpoint_name          = var.endpoint_name
  workgroup_name         = var.workgroup_name
  subnet_ids             = var.subnet_ids
  owner_account          = var.owner_account
  vpc_security_group_ids = var.vpc_security_group_ids
  region                 = var.region
}