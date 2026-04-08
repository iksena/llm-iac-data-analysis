resource "aws_servicecatalog_constraint" "this" {
  parameters      = var.parameters
  portfolio_id    = var.portfolio_id
  product_id      = var.product_id
  type            = var.type
  region          = var.region
  accept_language = var.accept_language
  description     = var.description

  timeouts {
    create = "3m"
    read   = "10m"
    update = "3m"
    delete = "3m"
  }
}