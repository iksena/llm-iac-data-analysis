resource "aws_xray_sampling_rule" "this" {
  region         = var.region
  rule_name      = var.rule_name
  resource_arn   = var.resource_arn
  priority       = var.priority
  fixed_rate     = var.fixed_rate
  reservoir_size = var.reservoir_size
  service_name   = var.service_name
  service_type   = var.service_type
  host           = var.host
  http_method    = var.http_method
  url_path       = var.url_path
  version        = var.rule_version
  attributes     = var.attributes
  tags           = var.tags
}