resource "aws_shield_drt_access_role_arn_association" "this" {
  role_arn = var.role_arn

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}