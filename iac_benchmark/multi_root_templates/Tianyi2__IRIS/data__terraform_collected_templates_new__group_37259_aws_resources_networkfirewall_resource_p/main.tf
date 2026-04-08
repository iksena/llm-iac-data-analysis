resource "aws_networkfirewall_resource_policy" "this" {
  region       = var.region
  policy       = var.policy
  resource_arn = var.resource_arn
}