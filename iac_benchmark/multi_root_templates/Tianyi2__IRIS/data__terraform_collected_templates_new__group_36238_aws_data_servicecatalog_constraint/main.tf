data "aws_servicecatalog_constraint" "this" {
  id              = var.id
  region          = var.region
  accept_language = var.accept_language
}