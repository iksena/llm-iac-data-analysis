resource "aws_quicksight_namespace" "this" {
  namespace      = var.namespace
  aws_account_id = var.aws_account_id
  identity_store = var.identity_store
  region         = var.region
  tags           = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}