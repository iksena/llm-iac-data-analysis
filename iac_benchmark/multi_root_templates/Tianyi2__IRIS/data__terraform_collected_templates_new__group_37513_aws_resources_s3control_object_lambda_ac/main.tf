resource "aws_s3control_object_lambda_access_point_policy" "this" {
  region     = var.region
  account_id = var.account_id
  name       = var.name
  policy     = var.policy
}