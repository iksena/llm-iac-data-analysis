data "aws_cloudformation_type" "this" {
  region     = var.region
  arn        = var.arn
  type       = var.type
  type_name  = var.type_name
  version_id = var.version_id
}