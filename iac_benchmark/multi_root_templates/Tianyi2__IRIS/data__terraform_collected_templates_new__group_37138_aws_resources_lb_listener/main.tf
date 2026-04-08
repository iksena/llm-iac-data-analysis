resource "aws_lb_listener" "this" {
  load_balancer_arn                                                     = var.load_balancer_arn
  port                                                                  = var.port
  protocol                                                              = var.protocol
  ssl_policy                                                            = var.ssl_policy
  certificate_arn                                                       = var.certificate_arn
  alpn_policy                                                           = var.alpn_policy
  tcp_idle_timeout_seconds                                              = var.tcp_idle_timeout_seconds
  routing_http_response_server_enabled                                  = var.routing_http_response_server_enabled
  routing_http_response_strict_transport_security_header_value          = var.routing_http_response_strict_transport_security_header_value
  routing_http_response_access_control_allow_origin_header_value        = var.routing_http_response_access_control_allow_origin_header_value
  routing_http_response_access_control_allow_methods_header_value       = var.routing_http_response_access_control_allow_methods_header_value
  routing_http_response_access_control_allow_headers_header_value       = var.routing_http_response_access_control_allow_headers_header_value
  routing_http_response_access_control_allow_credentials_header_value   = var.routing_http_response_access_control_allow_credentials_header_value
  routing_http_response_access_control_expose_headers_header_value      = var.routing_http_response_access_control_expose_headers_header_value
  routing_http_response_access_control_max_age_header_value             = var.routing_http_response_access_control_max_age_header_value
  routing_http_response_content_security_policy_header_value            = var.routing_http_response_content_security_policy_header_value
  routing_http_response_x_content_type_options_header_value             = var.routing_http_response_x_content_type_options_header_value
  routing_http_response_x_frame_options_header_value                    = var.routing_http_response_x_frame_options_header_value
  routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = var.routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name
  routing_http_request_x_amzn_mtls_clientcert_issuer_header_name        = var.routing_http_request_x_amzn_mtls_clientcert_issuer_header_name
  routing_http_request_x_amzn_mtls_clientcert_subject_header_name       = var.routing_http_request_x_amzn_mtls_clientcert_subject_header_name
  routing_http_request_x_amzn_mtls_clientcert_validity_header_name      = var.routing_http_request_x_amzn_mtls_clientcert_validity_header_name
  routing_http_request_x_amzn_mtls_clientcert_leaf_header_name          = var.routing_http_request_x_amzn_mtls_clientcert_leaf_header_name
  routing_http_request_x_amzn_mtls_clientcert_header_name               = var.routing_http_request_x_amzn_mtls_clientcert_header_name
  routing_http_request_x_amzn_tls_version_header_name                   = var.routing_http_request_x_amzn_tls_version_header_name
  routing_http_request_x_amzn_tls_cipher_suite_header_name              = var.routing_http_request_x_amzn_tls_cipher_suite_header_name
  tags                                                                  = var.tags

  dynamic "default_action" {
    for_each = var.default_action
    content {
      type             = default_action.value.type
      target_group_arn = default_action.value.target_group_arn
      order            = default_action.value.order

      dynamic "authenticate_cognito" {
        for_each = default_action.value.authenticate_cognito != null ? [default_action.value.authenticate_cognito] : []
        content {
          user_pool_arn              = authenticate_cognito.value.user_pool_arn
          user_pool_client_id        = authenticate_cognito.value.user_pool_client_id
          user_pool_domain           = authenticate_cognito.value.user_pool_domain
          on_unauthenticated_request = authenticate_cognito.value.on_unauthenticated_request
          scope                      = authenticate_cognito.value.scope
          session_cookie_name        = authenticate_cognito.value.session_cookie_name
          session_timeout            = authenticate_cognito.value.session_timeout

          authentication_request_extra_params = authenticate_cognito.value.authentication_request_extra_params
        }
      }

      dynamic "authenticate_oidc" {
        for_each = default_action.value.authenticate_oidc != null ? [default_action.value.authenticate_oidc] : []
        content {
          authorization_endpoint              = authenticate_oidc.value.authorization_endpoint
          client_id                           = authenticate_oidc.value.client_id
          client_secret                       = authenticate_oidc.value.client_secret
          issuer                              = authenticate_oidc.value.issuer
          token_endpoint                      = authenticate_oidc.value.token_endpoint
          user_info_endpoint                  = authenticate_oidc.value.user_info_endpoint
          on_unauthenticated_request          = authenticate_oidc.value.on_unauthenticated_request
          scope                               = authenticate_oidc.value.scope
          session_cookie_name                 = authenticate_oidc.value.session_cookie_name
          session_timeout                     = authenticate_oidc.value.session_timeout
          authentication_request_extra_params = authenticate_oidc.value.authentication_request_extra_params
        }
      }

      dynamic "fixed_response" {
        for_each = default_action.value.fixed_response != null ? [default_action.value.fixed_response] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.status_code
        }
      }

      dynamic "forward" {
        for_each = default_action.value.forward != null ? [default_action.value.forward] : []
        content {
          dynamic "target_group" {
            for_each = forward.value.target_group
            content {
              arn    = target_group.value.arn
              weight = target_group.value.weight
            }
          }

          dynamic "stickiness" {
            for_each = forward.value.stickiness != null ? [forward.value.stickiness] : []
            content {
              duration = stickiness.value.duration
              enabled  = stickiness.value.enabled
            }
          }
        }
      }

      dynamic "redirect" {
        for_each = default_action.value.redirect != null ? [default_action.value.redirect] : []
        content {
          status_code = redirect.value.status_code
          host        = redirect.value.host
          path        = redirect.value.path
          port        = redirect.value.port
          protocol    = redirect.value.protocol
          query       = redirect.value.query
        }
      }
    }
  }

  dynamic "mutual_authentication" {
    for_each = var.mutual_authentication != null ? [var.mutual_authentication] : []
    content {
      mode                             = mutual_authentication.value.mode
      trust_store_arn                  = mutual_authentication.value.trust_store_arn
      advertise_trust_store_ca_names   = mutual_authentication.value.advertise_trust_store_ca_names
      ignore_client_certificate_expiry = mutual_authentication.value.ignore_client_certificate_expiry
    }
  }
}