data "aws_oam_sink" "this" {
  region          = var.region
  sink_identifier = var.sink_identifier
}