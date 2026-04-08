resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  region             = var.region
  inline_policy      = var.inline_policy
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn
}