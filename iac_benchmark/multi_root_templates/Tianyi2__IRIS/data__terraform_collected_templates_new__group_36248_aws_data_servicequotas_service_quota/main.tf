data "aws_servicequotas_service_quota" "this" {
  region       = var.region
  service_code = var.service_code
  quota_code   = var.quota_code
  quota_name   = var.quota_name
}