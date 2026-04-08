resource "aws_vpc_endpoint_connection_accepter" "this" {
  region                  = var.region
  vpc_endpoint_id         = var.vpc_endpoint_id
  vpc_endpoint_service_id = var.vpc_endpoint_service_id
}