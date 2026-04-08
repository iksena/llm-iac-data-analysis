resource "aws_networkmanager_global_network" "this" {
  description = var.description
  tags        = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
    update = var.update_timeout
  }
}