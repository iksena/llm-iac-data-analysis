resource "aws_redshiftserverless_usage_limit" "this" {
  region        = var.region
  amount        = var.amount
  breach_action = var.breach_action
  period        = var.period
  resource_arn  = var.resource_arn
  usage_type    = var.usage_type
}