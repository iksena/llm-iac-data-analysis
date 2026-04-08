resource "aws_efs_mount_target" "this" {
  region          = var.region
  file_system_id  = var.file_system_id
  subnet_id       = var.subnet_id
  ip_address      = var.ip_address
  ip_address_type = var.ip_address_type
  ipv6_address    = var.ipv6_address
  security_groups = var.security_groups

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}