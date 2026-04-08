data "aws_networkfirewall_resource_policy" "this" {
  region       = var.region
  resource_arn = var.resource_arn
}