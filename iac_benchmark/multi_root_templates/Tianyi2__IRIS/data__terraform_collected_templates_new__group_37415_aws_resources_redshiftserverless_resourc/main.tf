resource "aws_redshiftserverless_resource_policy" "this" {
  resource_arn = var.resource_arn
  policy       = var.policy
  region       = var.region
}