resource "aws_sagemaker_device" "this" {
  region            = var.region
  device_fleet_name = var.device_fleet_name

  device {
    description    = var.device_description
    device_name    = var.device_name
    iot_thing_name = var.iot_thing_name
  }
}