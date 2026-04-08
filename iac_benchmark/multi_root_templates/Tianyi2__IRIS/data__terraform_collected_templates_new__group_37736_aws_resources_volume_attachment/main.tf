resource "aws_volume_attachment" "this" {
  region                         = var.region
  device_name                    = var.device_name
  instance_id                    = var.instance_id
  volume_id                      = var.volume_id
  force_detach                   = var.force_detach
  skip_destroy                   = var.skip_destroy
  stop_instance_before_detaching = var.stop_instance_before_detaching
}