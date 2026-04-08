resource "aws_api_gateway_account" "this" {
  region              = var.region
  cloudwatch_role_arn = var.cloudwatch_role_arn
}