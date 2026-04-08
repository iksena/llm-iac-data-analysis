resource "aws_appsync_api_key" "this" {
  region      = var.region
  api_id      = var.api_id
  description = var.description
  expires     = var.expires
}