data "aws_lakeformation_resource" "this" {
  arn    = var.arn
  region = var.region
}