resource "aws_amplify_webhook" "this" {
  region      = var.region
  app_id      = var.app_id
  branch_name = var.branch_name
  description = var.description
}