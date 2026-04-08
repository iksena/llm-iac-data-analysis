resource "aws_appsync_type" "this" {
  region     = var.region
  api_id     = var.api_id
  format     = var.format
  definition = var.definition
}