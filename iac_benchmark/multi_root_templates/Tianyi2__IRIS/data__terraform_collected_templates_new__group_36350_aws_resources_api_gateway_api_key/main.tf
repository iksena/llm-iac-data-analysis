resource "aws_api_gateway_api_key" "this" {
  region      = var.region
  name        = var.name
  customer_id = var.customer_id
  description = var.description
  enabled     = var.enabled
  value       = var.value
  tags        = var.tags
}