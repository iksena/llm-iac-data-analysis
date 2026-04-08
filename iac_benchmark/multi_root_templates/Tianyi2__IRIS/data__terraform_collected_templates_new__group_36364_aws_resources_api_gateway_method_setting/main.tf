resource "aws_api_gateway_method_settings" "this" {
  region      = var.region
  rest_api_id = var.rest_api_id
  stage_name  = var.stage_name
  method_path = var.method_path

  settings {
    metrics_enabled                            = var.settings_metrics_enabled
    logging_level                              = var.settings_logging_level
    data_trace_enabled                         = var.settings_data_trace_enabled
    throttling_burst_limit                     = var.settings_throttling_burst_limit
    throttling_rate_limit                      = var.settings_throttling_rate_limit
    caching_enabled                            = var.settings_caching_enabled
    cache_ttl_in_seconds                       = var.settings_cache_ttl_in_seconds
    cache_data_encrypted                       = var.settings_cache_data_encrypted
    require_authorization_for_cache_control    = var.settings_require_authorization_for_cache_control
    unauthorized_cache_control_header_strategy = var.settings_unauthorized_cache_control_header_strategy
  }
}