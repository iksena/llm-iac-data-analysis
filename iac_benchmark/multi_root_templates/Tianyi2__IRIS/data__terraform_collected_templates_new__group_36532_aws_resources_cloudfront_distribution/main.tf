resource "aws_cloudfront_distribution" "this" {
  aliases                         = var.aliases
  anycast_ip_list_id              = var.anycast_ip_list_id
  comment                         = var.comment
  continuous_deployment_policy_id = var.continuous_deployment_policy_id
  default_root_object             = var.default_root_object
  enabled                         = var.enabled
  is_ipv6_enabled                 = var.is_ipv6_enabled
  http_version                    = var.http_version
  price_class                     = var.price_class
  staging                         = var.staging
  tags                            = var.tags
  web_acl_id                      = var.web_acl_id
  retain_on_delete                = var.retain_on_delete
  wait_for_deployment             = var.wait_for_deployment

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  default_cache_behavior {
    allowed_methods            = var.default_cache_behavior.allowed_methods
    cached_methods             = var.default_cache_behavior.cached_methods
    cache_policy_id            = var.default_cache_behavior.cache_policy_id
    compress                   = var.default_cache_behavior.compress
    default_ttl                = var.default_cache_behavior.default_ttl
    field_level_encryption_id  = var.default_cache_behavior.field_level_encryption_id
    max_ttl                    = var.default_cache_behavior.max_ttl
    min_ttl                    = var.default_cache_behavior.min_ttl
    origin_request_policy_id   = var.default_cache_behavior.origin_request_policy_id
    realtime_log_config_arn    = var.default_cache_behavior.realtime_log_config_arn
    response_headers_policy_id = var.default_cache_behavior.response_headers_policy_id
    smooth_streaming           = var.default_cache_behavior.smooth_streaming
    target_origin_id           = var.default_cache_behavior.target_origin_id
    trusted_key_groups         = var.default_cache_behavior.trusted_key_groups
    trusted_signers            = var.default_cache_behavior.trusted_signers
    viewer_protocol_policy     = var.default_cache_behavior.viewer_protocol_policy

    dynamic "forwarded_values" {
      for_each = var.default_cache_behavior.forwarded_values != null ? [var.default_cache_behavior.forwarded_values] : []
      content {
        query_string            = forwarded_values.value.query_string
        headers                 = forwarded_values.value.headers
        query_string_cache_keys = forwarded_values.value.query_string_cache_keys

        cookies {
          forward           = forwarded_values.value.cookies.forward
          whitelisted_names = forwarded_values.value.cookies.whitelisted_names
        }
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_association
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }

    dynamic "function_association" {
      for_each = var.default_cache_behavior.function_association
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }

    dynamic "grpc_config" {
      for_each = var.default_cache_behavior.grpc_config != null ? [var.default_cache_behavior.grpc_config] : []
      content {
        enabled = grpc_config.value.enabled
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      bucket          = logging_config.value.bucket
      include_cookies = logging_config.value.include_cookies
      prefix          = logging_config.value.prefix
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    content {
      path_pattern               = ordered_cache_behavior.value.path_pattern
      allowed_methods            = ordered_cache_behavior.value.allowed_methods
      cached_methods             = ordered_cache_behavior.value.cached_methods
      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id
      compress                   = ordered_cache_behavior.value.compress
      default_ttl                = ordered_cache_behavior.value.default_ttl
      field_level_encryption_id  = ordered_cache_behavior.value.field_level_encryption_id
      max_ttl                    = ordered_cache_behavior.value.max_ttl
      min_ttl                    = ordered_cache_behavior.value.min_ttl
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id
      realtime_log_config_arn    = ordered_cache_behavior.value.realtime_log_config_arn
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id
      smooth_streaming           = ordered_cache_behavior.value.smooth_streaming
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      trusted_key_groups         = ordered_cache_behavior.value.trusted_key_groups
      trusted_signers            = ordered_cache_behavior.value.trusted_signers
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy

      dynamic "forwarded_values" {
        for_each = ordered_cache_behavior.value.forwarded_values != null ? [ordered_cache_behavior.value.forwarded_values] : []
        content {
          query_string            = forwarded_values.value.query_string
          headers                 = forwarded_values.value.headers
          query_string_cache_keys = forwarded_values.value.query_string_cache_keys

          cookies {
            forward           = forwarded_values.value.cookies.forward
            whitelisted_names = forwarded_values.value.cookies.whitelisted_names
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_association
        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_association
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }

      dynamic "grpc_config" {
        for_each = ordered_cache_behavior.value.grpc_config != null ? [ordered_cache_behavior.value.grpc_config] : []
        content {
          enabled = grpc_config.value.enabled
        }
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin
    content {
      domain_name                 = origin.value.domain_name
      origin_id                   = origin.value.origin_id
      connection_attempts         = origin.value.connection_attempts
      connection_timeout          = origin.value.connection_timeout
      origin_access_control_id    = origin.value.origin_access_control_id
      origin_path                 = origin.value.origin_path
      response_completion_timeout = origin.value.response_completion_timeout

      dynamic "custom_header" {
        for_each = origin.value.custom_header
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }

      dynamic "origin_shield" {
        for_each = origin.value.origin_shield != null ? [origin.value.origin_shield] : []
        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config != null ? [origin.value.s3_origin_config] : []
        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "vpc_origin_config" {
        for_each = origin.value.vpc_origin_config != null ? [origin.value.vpc_origin_config] : []
        content {
          vpc_origin_id            = vpc_origin_config.value.vpc_origin_id
          origin_keepalive_timeout = vpc_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = vpc_origin_config.value.origin_read_timeout
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_group
    content {
      origin_id = origin_group.value.origin_id

      failover_criteria {
        status_codes = origin_group.value.failover_criteria.status_codes
      }

      dynamic "member" {
        for_each = origin_group.value.member
        content {
          origin_id = member.value.origin_id
        }
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restrictions.geo_restriction.restriction_type
      locations        = var.restrictions.geo_restriction.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.viewer_certificate.acm_certificate_arn
    cloudfront_default_certificate = var.viewer_certificate.cloudfront_default_certificate
    iam_certificate_id             = var.viewer_certificate.iam_certificate_id
    minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
    ssl_support_method             = var.viewer_certificate.ssl_support_method
  }
}