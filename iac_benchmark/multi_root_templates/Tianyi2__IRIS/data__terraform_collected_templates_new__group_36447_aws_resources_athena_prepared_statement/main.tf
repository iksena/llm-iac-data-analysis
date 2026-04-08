resource "aws_athena_prepared_statement" "this" {
  region          = var.region
  name            = var.name
  workgroup       = var.workgroup
  query_statement = var.query_statement
  description     = var.description

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}