resource "aws_ec2_availability_zone_group" "this" {
  region        = var.region
  group_name    = var.group_name
  opt_in_status = var.opt_in_status
}