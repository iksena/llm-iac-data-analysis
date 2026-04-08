resource "aws_s3control_access_grants_location" "this" {
  region         = var.region
  account_id     = var.account_id
  iam_role_arn   = var.iam_role_arn
  location_scope = var.location_scope
  tags           = var.tags
}