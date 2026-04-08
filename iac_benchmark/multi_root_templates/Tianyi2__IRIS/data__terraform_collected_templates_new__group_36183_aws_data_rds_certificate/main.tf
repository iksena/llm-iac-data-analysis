data "aws_rds_certificate" "this" {
  region                   = var.region
  id                       = var.id
  default_for_new_launches = var.default_for_new_launches
  latest_valid_till        = var.latest_valid_till
}