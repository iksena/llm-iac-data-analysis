resource "aws_elasticache_user" "this" {
  access_string = var.access_string
  engine        = var.engine
  user_id       = var.user_id
  user_name     = var.user_name

  region               = var.region
  no_password_required = var.no_password_required
  passwords            = var.passwords
  tags                 = var.tags

  dynamic "authentication_mode" {
    for_each = var.authentication_mode != null ? [var.authentication_mode] : []
    content {
      type      = authentication_mode.value.type
      passwords = authentication_mode.value.passwords
    }
  }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}