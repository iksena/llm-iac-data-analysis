resource "aws_lightsail_disk_attachment" "this" {
  disk_name     = var.disk_name
  disk_path     = var.disk_path
  instance_name = var.instance_name
  region        = var.region
}