resource "aws_ssoadmin_permission_set" "this" {
  region           = var.region
  description      = var.description
  instance_arn     = var.instance_arn
  name             = var.name
  relay_state      = var.relay_state
  session_duration = var.session_duration
  tags             = var.tags

  timeouts {
    update = "10m"
  }
}