resource "aws_media_package_channel" "this" {
  region      = var.region
  channel_id  = var.channel_id
  description = var.description
  tags        = var.tags
}