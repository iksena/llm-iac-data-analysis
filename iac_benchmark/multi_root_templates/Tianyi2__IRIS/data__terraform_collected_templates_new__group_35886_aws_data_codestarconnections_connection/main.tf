data "aws_codestarconnections_connection" "this" {
  region = var.region
  arn    = var.arn
  name   = var.name
}