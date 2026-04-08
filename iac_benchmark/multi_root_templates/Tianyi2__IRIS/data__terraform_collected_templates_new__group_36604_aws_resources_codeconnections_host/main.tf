resource "aws_codeconnections_host" "this" {
  region            = var.region
  name              = var.name
  provider_endpoint = var.provider_endpoint
  provider_type     = var.provider_type

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration != null ? [var.vpc_configuration] : []
    content {
      security_group_ids = vpc_configuration.value.security_group_ids
      subnet_ids         = vpc_configuration.value.subnet_ids
      tls_certificate    = vpc_configuration.value.tls_certificate
      vpc_id             = vpc_configuration.value.vpc_id
    }
  }
}