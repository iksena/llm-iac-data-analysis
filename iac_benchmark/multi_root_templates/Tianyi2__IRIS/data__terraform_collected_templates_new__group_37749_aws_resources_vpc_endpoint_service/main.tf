resource "aws_vpc_endpoint_service" "this" {
  region                     = var.region
  acceptance_required        = var.acceptance_required
  allowed_principals         = var.allowed_principals
  gateway_load_balancer_arns = var.gateway_load_balancer_arns
  network_load_balancer_arns = var.network_load_balancer_arns
  tags                       = var.tags
  private_dns_name           = var.private_dns_name
  supported_ip_address_types = var.supported_ip_address_types
  supported_regions          = var.supported_regions
}