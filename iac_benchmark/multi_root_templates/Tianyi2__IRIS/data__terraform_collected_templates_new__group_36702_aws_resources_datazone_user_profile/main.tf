resource "aws_datazone_user_profile" "this" {
  domain_identifier = var.domain_identifier
  user_identifier   = var.user_identifier
  region            = var.region
  status            = var.status
  user_type         = var.user_type

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
  }
}