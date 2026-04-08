resource "aws_lightsail_disk" "this" {
  availability_zone = var.availability_zone
  name              = var.name
  size_in_gb        = var.size_in_gb
  region            = var.region
  tags              = var.tags
}