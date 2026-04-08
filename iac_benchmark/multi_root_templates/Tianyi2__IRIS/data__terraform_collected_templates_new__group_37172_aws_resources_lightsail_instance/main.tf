resource "aws_lightsail_instance" "this" {
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  name              = var.name

  ip_address_type = var.ip_address_type
  key_pair_name   = var.key_pair_name
  region          = var.region
  tags            = var.tags
  user_data       = var.user_data

  dynamic "add_on" {
    for_each = var.add_on != null ? [var.add_on] : []
    content {
      snapshot_time = add_on.value.snapshot_time
      status        = add_on.value.status
      type          = add_on.value.type
    }
  }
}