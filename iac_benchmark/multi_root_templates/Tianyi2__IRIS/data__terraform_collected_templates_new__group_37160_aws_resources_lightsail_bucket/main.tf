resource "aws_lightsail_bucket" "this" {
  name         = var.name
  bundle_id    = var.bundle_id
  force_delete = var.force_delete
  region       = var.region
  tags         = var.tags
}