resource "aws_api_gateway_usage_plan" "this" {
  region       = var.region
  name         = var.name
  description  = var.description
  product_code = var.product_code
  tags         = var.tags

  dynamic "api_stages" {
    for_each = var.api_stages
    content {
      api_id = api_stages.value.api_id
      stage  = api_stages.value.stage

      dynamic "throttle" {
        for_each = api_stages.value.throttle != null ? [api_stages.value.throttle] : []
        content {
          path        = throttle.value.path
          burst_limit = throttle.value.burst_limit
          rate_limit  = throttle.value.rate_limit
        }
      }
    }
  }

  dynamic "quota_settings" {
    for_each = var.quota_settings != null ? [var.quota_settings] : []
    content {
      limit  = quota_settings.value.limit
      offset = quota_settings.value.offset
      period = quota_settings.value.period
    }
  }

  dynamic "throttle_settings" {
    for_each = var.throttle_settings != null ? [var.throttle_settings] : []
    content {
      burst_limit = throttle_settings.value.burst_limit
      rate_limit  = throttle_settings.value.rate_limit
    }
  }
}