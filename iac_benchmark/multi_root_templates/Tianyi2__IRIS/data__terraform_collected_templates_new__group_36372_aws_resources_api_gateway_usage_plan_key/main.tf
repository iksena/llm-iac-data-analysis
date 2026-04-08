resource "aws_api_gateway_usage_plan_key" "this" {
  region        = var.region
  key_id        = var.key_id
  key_type      = var.key_type
  usage_plan_id = var.usage_plan_id
}