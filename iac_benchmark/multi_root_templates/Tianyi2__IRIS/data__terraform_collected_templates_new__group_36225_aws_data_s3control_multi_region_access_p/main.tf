data "aws_s3control_multi_region_access_point" "this" {
  region     = var.region
  account_id = var.account_id
  name       = var.name
}