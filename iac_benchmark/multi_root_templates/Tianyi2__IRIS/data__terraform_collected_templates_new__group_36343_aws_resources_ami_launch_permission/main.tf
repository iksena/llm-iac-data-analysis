resource "aws_ami_launch_permission" "this" {
  region                  = var.region
  account_id              = var.account_id
  group                   = var.group
  image_id                = var.image_id
  organization_arn        = var.organization_arn
  organizational_unit_arn = var.organizational_unit_arn
}