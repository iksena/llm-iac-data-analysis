resource "aws_service_discovery_instance" "this" {
  region      = var.region
  instance_id = var.instance_id
  service_id  = var.service_id
  attributes  = var.attributes
}