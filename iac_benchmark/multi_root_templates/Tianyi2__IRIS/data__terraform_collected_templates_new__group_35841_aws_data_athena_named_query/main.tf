data "aws_athena_named_query" "this" {
  name      = var.name
  region    = var.region
  workgroup = var.workgroup
}