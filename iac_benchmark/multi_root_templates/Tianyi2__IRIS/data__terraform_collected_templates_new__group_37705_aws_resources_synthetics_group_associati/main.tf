resource "aws_synthetics_group_association" "this" {
  region     = var.region
  group_name = var.group_name
  canary_arn = var.canary_arn
}