resource "aws_ebs_fast_snapshot_restore" "this" {
  region            = var.region
  availability_zone = var.availability_zone
  snapshot_id       = var.snapshot_id

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}