resource "aws_redshiftdata_statement" "this" {
  database           = var.database
  sql                = var.sql
  region             = var.region
  cluster_identifier = var.cluster_identifier
  db_user            = var.db_user
  secret_arn         = var.secret_arn
  statement_name     = var.statement_name
  with_event         = var.with_event
  workgroup_name     = var.workgroup_name
}