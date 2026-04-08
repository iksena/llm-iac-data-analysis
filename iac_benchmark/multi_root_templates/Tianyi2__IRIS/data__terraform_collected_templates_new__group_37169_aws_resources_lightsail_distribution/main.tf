resource "aws_lightsail_distribution" "this" {
  bundle_id = var.bundle_id
  name      = var.name

  origin {
    name            = var.origin_name
    region_name     = var.origin_region_name
    protocol_policy = var.origin_protocol_policy
  }

  default_cache_behavior {
    behavior = var.default_cache_behavior
  }

  dynamic "cache_behavior" {
    for_each = var.cache_behaviors
    content {
      behavior = cache_behavior.value.behavior
      path     = cache_behavior.value.path
    }
  }

  dynamic "cache_behavior_settings" {
    for_each = var.cache_behavior_settings != null ? [var.cache_behavior_settings] : []
    content {
      allowed_http_methods = cache_behavior_settings.value.allowed_http_methods
      cached_http_methods  = cache_behavior_settings.value.cached_http_methods
      default_ttl          = cache_behavior_settings.value.default_ttl
      maximum_ttl          = cache_behavior_settings.value.maximum_ttl
      minimum_ttl          = cache_behavior_settings.value.minimum_ttl

      dynamic "forwarded_cookies" {
        for_each = cache_behavior_settings.value.forwarded_cookies != null ? [cache_behavior_settings.value.forwarded_cookies] : []
        content {
          option             = forwarded_cookies.value.option
          cookies_allow_list = forwarded_cookies.value.cookies_allow_list
        }
      }

      dynamic "forwarded_headers" {
        for_each = cache_behavior_settings.value.forwarded_headers != null ? [cache_behavior_settings.value.forwarded_headers] : []
        content {
          option             = forwarded_headers.value.option
          headers_allow_list = forwarded_headers.value.headers_allow_list
        }
      }

      dynamic "forwarded_query_strings" {
        for_each = cache_behavior_settings.value.forwarded_query_strings != null ? [cache_behavior_settings.value.forwarded_query_strings] : []
        content {
          option                     = forwarded_query_strings.value.option
          query_strings_allowed_list = forwarded_query_strings.value.query_strings_allowed_list
        }
      }
    }
  }

  certificate_name = var.certificate_name
  ip_address_type  = var.ip_address_type
  is_enabled       = var.is_enabled
  region           = var.region
  tags             = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}