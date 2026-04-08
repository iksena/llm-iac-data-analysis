variable "load_balancer_arn" {
  description = "ARN of the load balancer"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:", var.load_balancer_arn))
    error_message = "resource_aws_lb_listener, load_balancer_arn must be a valid load balancer ARN."
  }
}

variable "default_action" {
  description = "Configuration block for default actions"
  type = list(object({
    type             = string
    target_group_arn = optional(string)
    order            = optional(number)

    authenticate_cognito = optional(object({
      user_pool_arn                       = string
      user_pool_client_id                 = string
      user_pool_domain                    = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      authentication_request_extra_params = optional(map(string))
    }))

    authenticate_oidc = optional(object({
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      token_endpoint                      = string
      user_info_endpoint                  = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      authentication_request_extra_params = optional(map(string))
    }))

    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(string)
    }))

    forward = optional(object({
      target_group = list(object({
        arn    = string
        weight = optional(number)
      }))
      stickiness = optional(object({
        duration = number
        enabled  = optional(bool)
      }))
    }))

    redirect = optional(object({
      status_code = string
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
    }))
  }))

  validation {
    condition = alltrue([
      for action in var.default_action : contains([
        "forward",
        "redirect",
        "fixed-response",
        "authenticate-cognito",
        "authenticate-oidc"
      ], action.type)
    ])
    error_message = "resource_aws_lb_listener, default_action type must be one of: forward, redirect, fixed-response, authenticate-cognito, authenticate-oidc."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.order == null || (action.order >= 1 && action.order <= 50000)
    ])
    error_message = "resource_aws_lb_listener, default_action order must be between 1 and 50000."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.authenticate_cognito == null || (
        action.authenticate_cognito.on_unauthenticated_request == null ||
        contains(["deny", "allow", "authenticate"], action.authenticate_cognito.on_unauthenticated_request)
      )
    ])
    error_message = "resource_aws_lb_listener, default_action authenticate_cognito on_unauthenticated_request must be one of: deny, allow, authenticate."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.authenticate_oidc == null || (
        action.authenticate_oidc.on_unauthenticated_request == null ||
        contains(["deny", "allow", "authenticate"], action.authenticate_oidc.on_unauthenticated_request)
      )
    ])
    error_message = "resource_aws_lb_listener, default_action authenticate_oidc on_unauthenticated_request must be one of: deny, allow, authenticate."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.fixed_response == null || (
        action.fixed_response.content_type == null ||
        contains([
          "text/plain",
          "text/css",
          "text/html",
          "application/javascript",
          "application/json"
        ], action.fixed_response.content_type)
      )
    ])
    error_message = "resource_aws_lb_listener, default_action fixed_response content_type must be one of: text/plain, text/css, text/html, application/javascript, application/json."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.fixed_response == null || (
        action.fixed_response.status_code == null ||
        can(regex("^[245]XX$", action.fixed_response.status_code))
      )
    ])
    error_message = "resource_aws_lb_listener, default_action fixed_response status_code must be 2XX, 4XX, or 5XX."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.forward == null || (
        action.forward.target_group != null &&
        length(action.forward.target_group) >= 1 &&
        length(action.forward.target_group) <= 5
      )
    ])
    error_message = "resource_aws_lb_listener, default_action forward target_group must contain between 1 and 5 target groups."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.forward == null || alltrue([
        for tg in action.forward.target_group :
        tg.weight == null || (tg.weight >= 0 && tg.weight <= 999)
      ])
    ])
    error_message = "resource_aws_lb_listener, default_action forward target_group weight must be between 0 and 999."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.forward == null || (
        action.forward.stickiness == null || (
          action.forward.stickiness.duration >= 1 &&
          action.forward.stickiness.duration <= 604800
        )
      )
    ])
    error_message = "resource_aws_lb_listener, default_action forward stickiness duration must be between 1 and 604800 seconds."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.redirect == null || (
        action.redirect.status_code == null ||
        contains(["HTTP_301", "HTTP_302"], action.redirect.status_code)
      )
    ])
    error_message = "resource_aws_lb_listener, default_action redirect status_code must be HTTP_301 or HTTP_302."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.redirect == null || (
        action.redirect.port == null ||
        can(regex("^(#{port}|[1-9][0-9]{0,4})$", action.redirect.port)) &&
        (action.redirect.port == "#{port}" || (
          tonumber(action.redirect.port) >= 1 && tonumber(action.redirect.port) <= 65535
        ))
      )
    ])
    error_message = "resource_aws_lb_listener, default_action redirect port must be between 1 and 65535 or #{port}."
  }

  validation {
    condition = alltrue([
      for action in var.default_action :
      action.redirect == null || (
        action.redirect.protocol == null ||
        contains(["HTTP", "HTTPS", "#{protocol}"], action.redirect.protocol)
      )
    ])
    error_message = "resource_aws_lb_listener, default_action redirect protocol must be HTTP, HTTPS, or #{protocol}."
  }
}

variable "port" {
  description = "Port on which the load balancer is listening"
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_lb_listener, port must be between 1 and 65535."
  }
}

variable "protocol" {
  description = "Protocol for connections from clients to the load balancer"
  type        = string
  default     = null

  validation {
    condition = var.protocol == null || contains([
      "HTTP", "HTTPS", "TCP", "TLS", "UDP", "TCP_UDP"
    ], var.protocol)
    error_message = "resource_aws_lb_listener, protocol must be one of: HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP."
  }
}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the listener"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ARN of the default SSL server certificate"
  type        = string
  default     = null

  validation {
    condition     = var.certificate_arn == null || can(regex("^arn:aws:", var.certificate_arn))
    error_message = "resource_aws_lb_listener, certificate_arn must be a valid ARN."
  }
}

variable "alpn_policy" {
  description = "Name of the Application-Layer Protocol Negotiation (ALPN) policy"
  type        = string
  default     = null

  validation {
    condition = var.alpn_policy == null || contains([
      "HTTP1Only", "HTTP2Only", "HTTP2Optional", "HTTP2Preferred", "None"
    ], var.alpn_policy)
    error_message = "resource_aws_lb_listener, alpn_policy must be one of: HTTP1Only, HTTP2Only, HTTP2Optional, HTTP2Preferred, None."
  }
}

variable "tcp_idle_timeout_seconds" {
  description = "TCP idle timeout value in seconds"
  type        = number
  default     = null

  validation {
    condition     = var.tcp_idle_timeout_seconds == null || (var.tcp_idle_timeout_seconds >= 60 && var.tcp_idle_timeout_seconds <= 6000)
    error_message = "resource_aws_lb_listener, tcp_idle_timeout_seconds must be between 60 and 6000."
  }
}

variable "routing_http_response_server_enabled" {
  description = "Enables you to allow or remove the HTTP response server header"
  type        = bool
  default     = null
}

variable "routing_http_response_strict_transport_security_header_value" {
  description = "Informs browsers that the site should only be accessed using HTTPS"
  type        = string
  default     = null
}

variable "routing_http_response_access_control_allow_origin_header_value" {
  description = "Specifies which origins are allowed to access the server"
  type        = string
  default     = null
}

variable "routing_http_response_access_control_allow_methods_header_value" {
  description = "Set which HTTP methods are allowed when accessing the server from a different origin"
  type        = string
  default     = null

  validation {
    condition     = var.routing_http_response_access_control_allow_methods_header_value == null || can(regex("^(GET|HEAD|POST|DELETE|CONNECT|OPTIONS|TRACE|PATCH)(,(GET|HEAD|POST|DELETE|CONNECT|OPTIONS|TRACE|PATCH))*$", replace(var.routing_http_response_access_control_allow_methods_header_value, " ", "")))
    error_message = "resource_aws_lb_listener, routing_http_response_access_control_allow_methods_header_value must contain only valid HTTP methods: GET, HEAD, POST, DELETE, CONNECT, OPTIONS, TRACE, PATCH."
  }
}

variable "routing_http_response_access_control_allow_headers_header_value" {
  description = "Specifies which headers can be used during the request"
  type        = string
  default     = null
}

variable "routing_http_response_access_control_allow_credentials_header_value" {
  description = "Specifies whether the browser should include credentials such as cookies or authentication when making requests"
  type        = string
  default     = null

  validation {
    condition     = var.routing_http_response_access_control_allow_credentials_header_value == null || var.routing_http_response_access_control_allow_credentials_header_value == "true"
    error_message = "resource_aws_lb_listener, routing_http_response_access_control_allow_credentials_header_value must be 'true'."
  }
}

variable "routing_http_response_access_control_expose_headers_header_value" {
  description = "Specifies which headers the browser can expose to the requesting client"
  type        = string
  default     = null
}

variable "routing_http_response_access_control_max_age_header_value" {
  description = "Specifies how long the results of a preflight request can be cached, in seconds"
  type        = number
  default     = null

  validation {
    condition     = var.routing_http_response_access_control_max_age_header_value == null || (var.routing_http_response_access_control_max_age_header_value >= 0 && var.routing_http_response_access_control_max_age_header_value <= 86400)
    error_message = "resource_aws_lb_listener, routing_http_response_access_control_max_age_header_value must be between 0 and 86400."
  }
}

variable "routing_http_response_content_security_policy_header_value" {
  description = "Specifies restrictions enforced by the browser to help minimize the risk of certain types of security threats"
  type        = string
  default     = null
}

variable "routing_http_response_x_content_type_options_header_value" {
  description = "Indicates whether the MIME types advertised in the Content-Type headers should be followed and not be changed"
  type        = string
  default     = null

  validation {
    condition     = var.routing_http_response_x_content_type_options_header_value == null || var.routing_http_response_x_content_type_options_header_value == "nosniff"
    error_message = "resource_aws_lb_listener, routing_http_response_x_content_type_options_header_value must be 'nosniff'."
  }
}

variable "routing_http_response_x_frame_options_header_value" {
  description = "Indicates whether the browser is allowed to render a page in a frame, iframe, embed or object"
  type        = string
  default     = null

  validation {
    condition = var.routing_http_response_x_frame_options_header_value == null || contains([
      "DENY", "SAMEORIGIN"
    ], var.routing_http_response_x_frame_options_header_value) || can(regex("^ALLOW-FROM https://", var.routing_http_response_x_frame_options_header_value))
    error_message = "resource_aws_lb_listener, routing_http_response_x_frame_options_header_value must be DENY, SAMEORIGIN, or ALLOW-FROM https://example.com."
  }
}

variable "routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Serial-Number HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_mtls_clientcert_issuer_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Issuer HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_mtls_clientcert_subject_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Subject HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_mtls_clientcert_validity_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Validity HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_mtls_clientcert_leaf_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Leaf HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_mtls_clientcert_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Mtls-Clientcert HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_tls_version_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Tls-Version HTTP request header"
  type        = string
  default     = null
}

variable "routing_http_request_x_amzn_tls_cipher_suite_header_name" {
  description = "Enables you to modify the header name of the X-Amzn-Tls-Cipher-Suite HTTP request header"
  type        = string
  default     = null
}

variable "mutual_authentication" {
  description = "The mutual authentication configuration information"
  type = object({
    mode                             = string
    trust_store_arn                  = optional(string)
    advertise_trust_store_ca_names   = optional(string)
    ignore_client_certificate_expiry = optional(bool)
  })
  default = null

  validation {
    condition = var.mutual_authentication == null || contains([
      "off", "passthrough", "verify"
    ], var.mutual_authentication.mode)
    error_message = "resource_aws_lb_listener, mutual_authentication mode must be one of: off, passthrough, verify."
  }

  validation {
    condition = var.mutual_authentication == null || (
      var.mutual_authentication.advertise_trust_store_ca_names == null ||
      contains(["off", "on"], var.mutual_authentication.advertise_trust_store_ca_names)
    )
    error_message = "resource_aws_lb_listener, mutual_authentication advertise_trust_store_ca_names must be 'off' or 'on'."
  }

  validation {
    condition = var.mutual_authentication == null || (
      var.mutual_authentication.mode != "verify" ||
      var.mutual_authentication.trust_store_arn != null
    )
    error_message = "resource_aws_lb_listener, mutual_authentication trust_store_arn is required when mode is 'verify'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}