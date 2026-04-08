resource "aws_s3control_multi_region_access_point_policy" "this" {
  region     = var.region
  account_id = var.account_id

  details {
    name   = var.details_name
    policy = var.details_policy
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
  }
}