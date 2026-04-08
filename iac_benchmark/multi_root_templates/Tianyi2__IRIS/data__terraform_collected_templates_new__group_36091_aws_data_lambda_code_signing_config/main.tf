data "aws_lambda_code_signing_config" "this" {
  arn    = var.arn
  region = var.region
}