resource "aws_rds_instance_state" "this" {
  identifier = var.identifier
  state      = var.state
  region     = var.region

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
  }
}