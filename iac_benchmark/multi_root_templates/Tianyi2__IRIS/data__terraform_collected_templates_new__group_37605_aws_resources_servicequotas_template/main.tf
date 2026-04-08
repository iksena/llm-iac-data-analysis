resource "aws_servicequotas_template" "this" {
  aws_region   = var.aws_region
  region       = var.region
  quota_code   = var.quota_code
  service_code = var.service_code
  value        = var.value
}