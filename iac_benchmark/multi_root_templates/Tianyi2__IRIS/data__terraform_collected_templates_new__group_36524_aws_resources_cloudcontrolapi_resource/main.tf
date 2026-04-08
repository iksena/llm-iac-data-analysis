resource "aws_cloudcontrolapi_resource" "this" {
  desired_state   = var.desired_state
  type_name       = var.type_name
  region          = var.region
  role_arn        = var.role_arn
  schema          = var.schema
  type_version_id = var.type_version_id
}