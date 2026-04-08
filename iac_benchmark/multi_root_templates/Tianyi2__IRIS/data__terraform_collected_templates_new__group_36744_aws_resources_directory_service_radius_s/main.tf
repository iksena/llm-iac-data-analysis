resource "aws_directory_service_radius_settings" "this" {
  authentication_protocol = var.authentication_protocol
  directory_id            = var.directory_id
  display_label           = var.display_label
  radius_port             = var.radius_port
  radius_retries          = var.radius_retries
  radius_servers          = var.radius_servers
  radius_timeout          = var.radius_timeout
  shared_secret           = var.shared_secret
  use_same_username       = var.use_same_username

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
    }
  }
}