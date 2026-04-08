resource "aws_pinpointsmsvoicev2_opt_out_list" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags
}