resource "aws_ec2_traffic_mirror_target" "this" {
  region                            = var.region
  description                       = var.description
  network_interface_id              = var.network_interface_id
  network_load_balancer_arn         = var.network_load_balancer_arn
  gateway_load_balancer_endpoint_id = var.gateway_load_balancer_endpoint_id
  tags                              = var.tags
}