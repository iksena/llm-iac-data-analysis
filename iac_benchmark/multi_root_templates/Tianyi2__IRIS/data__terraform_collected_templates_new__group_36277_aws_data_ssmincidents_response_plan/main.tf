data "aws_ssmincidents_response_plan" "this" {
  region = var.region
  arn    = var.arn
}