data "aws_servicecatalog_provisioning_artifacts" "this" {
  product_id      = var.product_id
  region          = var.region
  accept_language = var.accept_language
}