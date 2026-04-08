resource "aws_servicecatalog_portfolio_share" "this" {
  portfolio_id        = var.portfolio_id
  principal_id        = var.principal_id
  type                = var.type
  region              = var.region
  accept_language     = var.accept_language
  share_principals    = var.share_principals
  share_tag_options   = var.share_tag_options
  wait_for_acceptance = var.wait_for_acceptance

  timeouts {
    create = var.timeouts_create
    read   = var.timeouts_read
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}