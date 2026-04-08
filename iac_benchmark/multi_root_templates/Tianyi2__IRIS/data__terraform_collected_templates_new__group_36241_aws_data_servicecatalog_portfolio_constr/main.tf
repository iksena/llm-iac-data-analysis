data "aws_servicecatalog_portfolio_constraints" "this" {
  portfolio_id    = var.portfolio_id
  region          = var.region
  accept_language = var.accept_language
  product_id      = var.product_id
}