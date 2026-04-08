resource "aws_athena_named_query" "this" {
  region      = var.region
  name        = var.name
  workgroup   = var.workgroup
  database    = var.database
  query       = var.query
  description = var.description
}