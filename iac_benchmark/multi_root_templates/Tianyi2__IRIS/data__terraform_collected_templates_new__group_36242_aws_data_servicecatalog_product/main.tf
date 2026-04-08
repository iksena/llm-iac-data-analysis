data "aws_servicecatalog_product" "this" {
  id              = var.id
  region          = var.region
  accept_language = var.accept_language
}