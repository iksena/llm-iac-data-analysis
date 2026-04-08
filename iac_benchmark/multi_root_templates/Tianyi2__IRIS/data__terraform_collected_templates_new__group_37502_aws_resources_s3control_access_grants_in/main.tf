resource "aws_s3control_access_grants_instance" "this" {
  region              = var.region
  account_id          = var.account_id
  identity_center_arn = var.identity_center_arn
  tags                = var.tags
}