resource "aws_rds_reserved_instance" "this" {
  offering_id    = var.offering_id
  region         = var.region
  instance_count = var.instance_count
  reservation_id = var.reservation_id
  tags           = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}