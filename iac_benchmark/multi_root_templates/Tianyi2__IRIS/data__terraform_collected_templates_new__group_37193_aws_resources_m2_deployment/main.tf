resource "aws_m2_deployment" "this" {
  environment_id      = var.environment_id
  application_id      = var.application_id
  application_version = var.application_version
  start               = var.start

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}