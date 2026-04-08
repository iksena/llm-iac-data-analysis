resource "aws_servicequotas_service_quota" "this" {
  region       = var.region
  quota_code   = var.quota_code
  service_code = var.service_code
  value        = var.value
}