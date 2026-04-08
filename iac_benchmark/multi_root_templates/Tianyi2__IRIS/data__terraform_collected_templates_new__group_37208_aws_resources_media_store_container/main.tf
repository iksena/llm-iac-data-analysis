resource "aws_media_store_container" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags
}