resource "aws_ami_from_instance" "this" {
  region                  = var.region
  name                    = var.name
  source_instance_id      = var.source_instance_id
  snapshot_without_reboot = var.snapshot_without_reboot
  tags                    = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}