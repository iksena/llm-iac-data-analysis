resource "aws_computeoptimizer_enrollment_status" "this" {
  region                  = var.region
  include_member_accounts = var.include_member_accounts
  status                  = var.status

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}