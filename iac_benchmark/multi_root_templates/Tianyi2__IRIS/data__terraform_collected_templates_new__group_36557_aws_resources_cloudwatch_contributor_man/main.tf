resource "aws_cloudwatch_contributor_managed_insight_rule" "this" {
  resource_arn  = var.resource_arn
  template_name = var.template_name
  region        = var.region
}