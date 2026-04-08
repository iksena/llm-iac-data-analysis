resource "aws_oam_sink" "this" {
  name   = var.name
  region = var.region
  tags   = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}