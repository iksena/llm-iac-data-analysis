resource "aws_redshift_partner" "this" {
  region             = var.region
  account_id         = var.account_id
  cluster_identifier = var.cluster_identifier
  database_name      = var.database_name
  partner_name       = var.partner_name
}