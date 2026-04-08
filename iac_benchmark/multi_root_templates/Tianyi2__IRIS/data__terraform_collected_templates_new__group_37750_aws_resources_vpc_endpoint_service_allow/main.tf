resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  region                  = var.region
  vpc_endpoint_service_id = var.vpc_endpoint_service_id
  principal_arn           = var.principal_arn
}