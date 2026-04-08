data "aws_cloudcontrolapi_resource" "this" {
  identifier      = var.identifier
  type_name       = var.type_name
  region          = var.region
  role_arn        = var.role_arn
  type_version_id = var.type_version_id
}