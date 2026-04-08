resource "aws_redshift_endpoint_authorization" "this" {
  region             = var.region
  account            = var.account
  cluster_identifier = var.cluster_identifier
  force_delete       = var.force_delete
  vpc_ids            = var.vpc_ids
}