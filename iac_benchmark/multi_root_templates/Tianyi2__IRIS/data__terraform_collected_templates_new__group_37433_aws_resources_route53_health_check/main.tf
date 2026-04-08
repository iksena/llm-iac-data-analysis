resource "aws_route53_health_check" "this" {
  reference_name                  = var.reference_name
  fqdn                            = var.fqdn
  ip_address                      = var.ip_address
  port                            = var.port
  type                            = var.type
  failure_threshold               = var.failure_threshold
  request_interval                = var.request_interval
  resource_path                   = var.resource_path
  search_string                   = var.search_string
  measure_latency                 = var.measure_latency
  invert_healthcheck              = var.invert_healthcheck
  disabled                        = var.disabled
  enable_sni                      = var.enable_sni
  child_healthchecks              = var.child_healthchecks
  child_health_threshold          = var.child_health_threshold
  cloudwatch_alarm_name           = var.cloudwatch_alarm_name
  cloudwatch_alarm_region         = var.cloudwatch_alarm_region
  insufficient_data_health_status = var.insufficient_data_health_status
  regions                         = var.regions
  routing_control_arn             = var.routing_control_arn
  tags                            = var.tags
  triggers                        = var.triggers
}