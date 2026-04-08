resource "aws_ssoadmin_managed_policy_attachment" "this" {
  region             = var.region
  instance_arn       = var.instance_arn
  managed_policy_arn = var.managed_policy_arn
  permission_set_arn = var.permission_set_arn

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}