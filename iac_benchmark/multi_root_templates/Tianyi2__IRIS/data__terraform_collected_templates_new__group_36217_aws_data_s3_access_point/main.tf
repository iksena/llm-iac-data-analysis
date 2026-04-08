data "aws_s3_access_point" "this" {
  account_id = var.account_id
  name       = var.name
  region     = var.region
}