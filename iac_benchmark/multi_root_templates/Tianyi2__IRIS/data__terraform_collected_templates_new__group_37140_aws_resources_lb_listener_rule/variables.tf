variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "listener_arn" {
  description = "The ARN of the listener to which to attach the rule"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:", var.listener_arn))
    error_message = "resource_aws_lb_listener_rule, listener_arn must be a valid ELB listener ARN starting with 'arn:aws:elasticloadbalancing:'."
  }
}

variable "priority" {
  description = "The priority for the rule between 1 and 50000"
  type        = number
  default     = null

  validation {
    condition     = var.priority == null || (var.priority >= 1 && var.priority <= 50000)
    error_message = "resource_aws_lb_listener_rule, priority must be between 1 and 50000."
  }
}

variable "action" {
  description = "Action blocks for the listener rule"
  type = list(object({
    type             = string
    target_group_arn = optional(string)
    order            = optional(number)
    authenticate_cognito = optional(object({
      user_pool_arn                       = string
      user_pool_client_id                 = string
      user_pool_domain                    = string
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
    }))
    authenticate_oidc = optional(object({
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      token_endpoint                      = string
      user_info_endpoint                  = string
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
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
        enabled  = bool
        duration = optional(number)
      }))
    }))
    redirect = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = string
    }))
  }))

  validation {
    condition = alltrue([
      for action in var.action : contains(["forward", "redirect", "fixed-response", "authenticate-cognito", "authenticate-oidc"], action.type)
    ])
    error_message = "resource_aws_lb_listener_rule, action type must be one of: forward, redirect, fixed-response, authenticate-cognito, authenticate-oidc."
  }

  validation {
    condition = alltrue([
      for action in var.action : action.order == null || (action.order >= 1 && action.order <= 50000)
    ])
    error_message = "resource_aws_lb_listener_rule, action order must be between 1 and 50000."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.authenticate_cognito == null || action.type == "authenticate-cognito"
    ])
    error_message = "resource_aws_lb_listener_rule, action authenticate_cognito block can only be specified when type is 'authenticate-cognito'."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.authenticate_oidc == null || action.type == "authenticate-oidc"
    ])
    error_message = "resource_aws_lb_listener_rule, action authenticate_oidc block can only be specified when type is 'authenticate-oidc'."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.fixed_response == null || action.type == "fixed-response"
    ])
    error_message = "resource_aws_lb_listener_rule, action fixed_response block can only be specified when type is 'fixed-response'."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.redirect == null || action.type == "redirect"
    ])
    error_message = "resource_aws_lb_listener_rule, action redirect block can only be specified when type is 'redirect'."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      (action.forward == null && action.target_group_arn == null) || (action.forward != null) != (action.target_group_arn != null)
    ])
    error_message = "resource_aws_lb_listener_rule, action cannot specify both forward block and target_group_arn."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.authenticate_cognito == null ||
      contains(["deny", "allow", "authenticate"], coalesce(action.authenticate_cognito.on_unauthenticated_request, "authenticate"))
    ])
    error_message = "resource_aws_lb_listener_rule, action authenticate_cognito on_unauthenticated_request must be one of: deny, allow, authenticate."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.authenticate_oidc == null ||
      contains(["deny", "allow", "authenticate"], coalesce(action.authenticate_oidc.on_unauthenticated_request, "authenticate"))
    ])
    error_message = "resource_aws_lb_listener_rule, action authenticate_oidc on_unauthenticated_request must be one of: deny, allow, authenticate."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.fixed_response == null ||
      contains(["text/plain", "text/css", "text/html", "application/javascript", "application/json"], action.fixed_response.content_type)
    ])
    error_message = "resource_aws_lb_listener_rule, action fixed_response content_type must be one of: text/plain, text/css, text/html, application/javascript, application/json."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.fixed_response == null || action.fixed_response.status_code == null ||
      can(regex("^[2-5]XX$", action.fixed_response.status_code))
    ])
    error_message = "resource_aws_lb_listener_rule, action fixed_response status_code must be 2XX, 4XX, or 5XX."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.redirect == null ||
      contains(["HTTP_301", "HTTP_302"], action.redirect.status_code)
    ])
    error_message = "resource_aws_lb_listener_rule, action redirect status_code must be HTTP_301 or HTTP_302."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.redirect == null || action.redirect.port == null ||
      can(regex("^(#{port}|[1-9][0-9]{0,4})$", action.redirect.port)) &&
      (action.redirect.port == "#{port}" || (tonumber(action.redirect.port) >= 1 && tonumber(action.redirect.port) <= 65535))
    ])
    error_message = "resource_aws_lb_listener_rule, action redirect port must be between 1 and 65535 or #{port}."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.redirect == null || action.redirect.protocol == null ||
      contains(["HTTP", "HTTPS", "#{protocol}"], action.redirect.protocol)
    ])
    error_message = "resource_aws_lb_listener_rule, action redirect protocol must be HTTP, HTTPS, or #{protocol}."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.forward == null || action.forward.stickiness == null || action.forward.stickiness.duration == null ||
      (action.forward.stickiness.duration >= 1 && action.forward.stickiness.duration <= 604800)
    ])
    error_message = "resource_aws_lb_listener_rule, action forward stickiness duration must be between 1 and 604800 seconds."
  }

  validation {
    condition = alltrue([
      for action in var.action :
      action.forward == null || alltrue([
        for tg in action.forward.target_group :
        tg.weight == null || (tg.weight >= 0 && tg.weight <= 999)
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, action forward target_group weight must be between 0 and 999."
  }
}

variable "condition" {
  description = "Condition blocks for the listener rule"
  type = list(object({
    host_header = optional(object({
      values = list(string)
    }))
    http_header = optional(object({
      http_header_name = string
      values           = list(string)
    }))
    http_request_method = optional(object({
      values = list(string)
    }))
    path_pattern = optional(object({
      values = list(string)
    }))
    query_string = optional(list(object({
      key   = optional(string)
      value = string
    })))
    source_ip = optional(object({
      values = list(string)
    }))
  }))

  validation {
    condition = alltrue([
      for condition in var.condition :
      length([
        condition.host_header,
        condition.http_header,
        condition.http_request_method,
        condition.path_pattern,
        condition.query_string,
        condition.source_ip
      ]) == 1
    ])
    error_message = "resource_aws_lb_listener_rule, condition must specify exactly one of: host_header, http_header, http_request_method, path_pattern, query_string, or source_ip."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.host_header == null || alltrue([
        for value in condition.host_header.values :
        length(value) <= 128
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, condition host_header values must not exceed 128 characters each."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.http_header == null || length(condition.http_header.http_header_name) <= 40
    ])
    error_message = "resource_aws_lb_listener_rule, condition http_header http_header_name must not exceed 40 characters."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.http_header == null || alltrue([
        for value in condition.http_header.values :
        length(value) <= 128
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, condition http_header values must not exceed 128 characters each."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.http_request_method == null || alltrue([
        for value in condition.http_request_method.values :
        length(value) <= 40
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, condition http_request_method values must not exceed 40 characters each."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.path_pattern == null || alltrue([
        for value in condition.path_pattern.values :
        length(value) <= 128
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, condition path_pattern values must not exceed 128 characters each."
  }

  validation {
    condition = alltrue([
      for condition in var.condition :
      condition.query_string == null || alltrue([
        for qs in condition.query_string :
        length(qs.value) <= 128 && (qs.key == null || length(qs.key) <= 128)
      ])
    ])
    error_message = "resource_aws_lb_listener_rule, condition query_string key and value must not exceed 128 characters each."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}