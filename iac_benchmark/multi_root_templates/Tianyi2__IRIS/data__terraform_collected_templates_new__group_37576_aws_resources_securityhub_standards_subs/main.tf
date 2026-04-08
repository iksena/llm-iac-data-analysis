resource "aws_securityhub_standards_subscription" "this" {
  region        = var.region
  standards_arn = var.standards_arn

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}