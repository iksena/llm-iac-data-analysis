data "aws_servicecatalog_portfolio" "this" {
  id              = var.id
  region          = var.region
  accept_language = var.accept_language
}