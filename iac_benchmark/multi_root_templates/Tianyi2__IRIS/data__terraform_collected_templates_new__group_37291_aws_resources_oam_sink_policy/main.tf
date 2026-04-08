resource "aws_oam_sink_policy" "this" {
  region          = var.region
  sink_identifier = var.sink_identifier
  policy          = var.policy

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
  }
}