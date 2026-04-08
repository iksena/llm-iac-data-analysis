data "aws_servicecatalog_launch_paths" "this" {
  product_id      = var.product_id
  region          = var.region
  accept_language = var.accept_language
}