resource "aws_servicecatalog_principal_portfolio_association" "this" {
  portfolio_id    = var.portfolio_id
  principal_arn   = var.principal_arn
  region          = var.region
  accept_language = var.accept_language
  principal_type  = var.principal_type

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }
}