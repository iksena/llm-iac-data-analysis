data "aws_servicequotas_service" "this" {
  region       = var.region
  service_name = var.service_name
}