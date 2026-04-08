resource "aws_servicecatalog_product_portfolio_association" "this" {
  portfolio_id        = var.portfolio_id
  product_id          = var.product_id
  region              = var.region
  accept_language     = var.accept_language
  source_portfolio_id = var.source_portfolio_id

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }
}