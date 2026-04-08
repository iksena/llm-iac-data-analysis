resource "aws_media_packagev2_channel_group" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags
}