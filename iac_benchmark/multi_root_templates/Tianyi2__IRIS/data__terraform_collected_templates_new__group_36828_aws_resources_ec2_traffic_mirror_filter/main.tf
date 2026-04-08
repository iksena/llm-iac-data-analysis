resource "aws_ec2_traffic_mirror_filter" "this" {
  region           = var.region
  description      = var.description
  network_services = var.network_services
  tags             = var.tags
}