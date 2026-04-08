resource "aws_fsx_openzfs_snapshot" "this" {
  name      = var.name
  region    = var.region
  tags      = var.tags
  volume_id = var.volume_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}