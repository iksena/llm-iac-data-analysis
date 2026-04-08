data "aws_cloudwatch_contributor_managed_insight_rules" "this" {
  region       = var.region
  resource_arn = var.resource_arn
}