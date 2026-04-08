variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the route. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = can(regex("^.{1,255}$", var.name))
    error_message = "resource_aws_appmesh_route, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which to create the route. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = can(regex("^.{1,255}$", var.mesh_name))
    error_message = "resource_aws_appmesh_route, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner. Defaults to the account ID the AWS provider is currently connected to."
  type        = string
  default     = null
}

variable "virtual_router_name" {
  description = "Name of the virtual router in which to create the route. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = can(regex("^.{1,255}$", var.virtual_router_name))
    error_message = "resource_aws_appmesh_route, virtual_router_name must be between 1 and 255 characters in length."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "spec" {
  description = "Route specification to apply."
  type = object({
    priority = optional(number)

    grpc_route = optional(object({
      action = object({
        weighted_target = list(object({
          virtual_node = string
          weight       = number
          port         = optional(number)
        }))
      })

      match = object({
        method_name  = optional(string)
        service_name = optional(string)
        port         = optional(number)

        metadata = optional(list(object({
          name   = string
          invert = optional(bool, false)

          match = optional(object({
            exact  = optional(string)
            prefix = optional(string)
            port   = optional(number)
            regex  = optional(string)
            suffix = optional(string)

            range = optional(object({
              end   = number
              start = number
            }))
          }))
        })))
      })

      retry_policy = optional(object({
        grpc_retry_events = optional(list(string))
        http_retry_events = optional(list(string))
        max_retries       = number
        tcp_retry_events  = optional(list(string))

        per_retry_timeout = object({
          unit  = string
          value = number
        })
      }))

      timeout = optional(object({
        idle = optional(object({
          unit  = string
          value = number
        }))

        per_request = optional(object({
          unit  = string
          value = number
        }))
      }))
    }))

    http2_route = optional(object({
      action = object({
        weighted_target = list(object({
          virtual_node = string
          weight       = number
          port         = optional(number)
        }))
      })

      match = object({
        prefix = optional(string)
        port   = optional(number)
        method = optional(string)
        scheme = optional(string)

        path = optional(object({
          exact = optional(string)
          regex = optional(string)
        }))

        header = optional(list(object({
          name   = string
          invert = optional(bool, false)

          match = optional(object({
            exact  = optional(string)
            prefix = optional(string)
            port   = optional(number)
            regex  = optional(string)
            suffix = optional(string)

            range = optional(object({
              end   = number
              start = number
            }))
          }))
        })))

        query_parameter = optional(list(object({
          name = string

          match = optional(object({
            exact = optional(string)
          }))
        })))
      })

      retry_policy = optional(object({
        http_retry_events = optional(list(string))
        max_retries       = number
        tcp_retry_events  = optional(list(string))

        per_retry_timeout = object({
          unit  = string
          value = number
        })
      }))

      timeout = optional(object({
        idle = optional(object({
          unit  = string
          value = number
        }))

        per_request = optional(object({
          unit  = string
          value = number
        }))
      }))
    }))

    http_route = optional(object({
      action = object({
        weighted_target = list(object({
          virtual_node = string
          weight       = number
          port         = optional(number)
        }))
      })

      match = object({
        prefix = optional(string)
        port   = optional(number)
        method = optional(string)
        scheme = optional(string)

        path = optional(object({
          exact = optional(string)
          regex = optional(string)
        }))

        header = optional(list(object({
          name   = string
          invert = optional(bool, false)

          match = optional(object({
            exact  = optional(string)
            prefix = optional(string)
            port   = optional(number)
            regex  = optional(string)
            suffix = optional(string)

            range = optional(object({
              end   = number
              start = number
            }))
          }))
        })))

        query_parameter = optional(list(object({
          name = string

          match = optional(object({
            exact = optional(string)
          }))
        })))
      })

      retry_policy = optional(object({
        http_retry_events = optional(list(string))
        max_retries       = number
        tcp_retry_events  = optional(list(string))

        per_retry_timeout = object({
          unit  = string
          value = number
        })
      }))

      timeout = optional(object({
        idle = optional(object({
          unit  = string
          value = number
        }))

        per_request = optional(object({
          unit  = string
          value = number
        }))
      }))
    }))

    tcp_route = optional(object({
      action = object({
        weighted_target = list(object({
          virtual_node = string
          weight       = number
          port         = optional(number)
        }))
      })

      timeout = optional(object({
        idle = optional(object({
          unit  = string
          value = number
        }))
      }))
    }))
  })

  validation {
    condition     = var.spec.priority == null || (var.spec.priority >= 0 && var.spec.priority <= 1000)
    error_message = "resource_aws_appmesh_route, priority must be between 0 and 1000."
  }

  validation {
    condition = sum([
      var.spec.grpc_route != null ? 1 : 0,
      var.spec.http2_route != null ? 1 : 0,
      var.spec.http_route != null ? 1 : 0,
      var.spec.tcp_route != null ? 1 : 0
    ]) == 1
    error_message = "resource_aws_appmesh_route, spec must specify exactly one of grpc_route, http2_route, http_route, or tcp_route."
  }

  # gRPC Route validations
  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.match.method_name == null || var.spec.grpc_route.match.service_name != null
    )
    error_message = "resource_aws_appmesh_route, grpc_route match method_name requires service_name to be specified."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : alltrue([
      for metadata in(var.spec.grpc_route.match.metadata != null ? var.spec.grpc_route.match.metadata : []) :
      can(regex("^.{1,50}$", metadata.name))
    ])
    error_message = "resource_aws_appmesh_route, grpc_route metadata name must be between 1 and 50 characters in length."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : alltrue([
      for metadata in(var.spec.grpc_route.match.metadata != null ? var.spec.grpc_route.match.metadata : []) :
      metadata.match == null ? true : alltrue([
        for field in [metadata.match.exact, metadata.match.prefix, metadata.match.regex, metadata.match.suffix] :
        field == null || (field != null && can(regex("^.{1,255}$", field)))
      ])
    ])
    error_message = "resource_aws_appmesh_route, grpc_route metadata match string fields must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.retry_policy == null ? true : (
        (var.spec.grpc_route.retry_policy.grpc_retry_events != null && length(var.spec.grpc_route.retry_policy.grpc_retry_events) > 0) ||
        (var.spec.grpc_route.retry_policy.http_retry_events != null && length(var.spec.grpc_route.retry_policy.http_retry_events) > 0) ||
        (var.spec.grpc_route.retry_policy.tcp_retry_events != null && length(var.spec.grpc_route.retry_policy.tcp_retry_events) > 0)
      )
    )
    error_message = "resource_aws_appmesh_route, grpc_route retry_policy must specify at least one retry event."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.grpc_route.retry_policy.grpc_retry_events != null ? var.spec.grpc_route.retry_policy.grpc_retry_events : []) :
        contains(["cancelled", "deadline-exceeded", "internal", "resource-exhausted", "unavailable"], event)
      ])
    )
    error_message = "resource_aws_appmesh_route, grpc_route grpc_retry_events must be one of: cancelled, deadline-exceeded, internal, resource-exhausted, unavailable."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.grpc_route.retry_policy.http_retry_events != null ? var.spec.grpc_route.retry_policy.http_retry_events : []) :
        contains(["client-error", "gateway-error", "server-error", "stream-error"], event)
      ])
    )
    error_message = "resource_aws_appmesh_route, grpc_route http_retry_events must be one of: client-error, gateway-error, server-error, stream-error."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.grpc_route.retry_policy.tcp_retry_events != null ? var.spec.grpc_route.retry_policy.tcp_retry_events : []) :
        event == "connection-error"
      ])
    )
    error_message = "resource_aws_appmesh_route, grpc_route tcp_retry_events must be 'connection-error'."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.retry_policy == null ? true : contains(["ms", "s"], var.spec.grpc_route.retry_policy.per_retry_timeout.unit)
    )
    error_message = "resource_aws_appmesh_route, grpc_route per_retry_timeout unit must be 'ms' or 's'."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.timeout == null ? true : (
        var.spec.grpc_route.timeout.idle == null ? true : (
          contains(["ms", "s"], var.spec.grpc_route.timeout.idle.unit) && var.spec.grpc_route.timeout.idle.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, grpc_route timeout idle unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : (
      var.spec.grpc_route.timeout == null ? true : (
        var.spec.grpc_route.timeout.per_request == null ? true : (
          contains(["ms", "s"], var.spec.grpc_route.timeout.per_request.unit) && var.spec.grpc_route.timeout.per_request.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, grpc_route timeout per_request unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.grpc_route == null ? true : alltrue([
      for target in var.spec.grpc_route.action.weighted_target :
      can(regex("^.{1,255}$", target.virtual_node)) && target.weight >= 0 && target.weight <= 100
    ])
    error_message = "resource_aws_appmesh_route, grpc_route weighted_target virtual_node must be 1-255 characters and weight must be 0-100."
  }

  # HTTP/HTTP2 Route validations
  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.match.prefix == null || can(regex("^/.*", var.spec.http_route.match.prefix))
    )
    error_message = "resource_aws_appmesh_route, http_route match prefix must start with '/'."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.match.prefix == null || can(regex("^/.*", var.spec.http2_route.match.prefix))
    )
    error_message = "resource_aws_appmesh_route, http2_route match prefix must start with '/'."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.match.method == null || contains(["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"], var.spec.http_route.match.method)
    )
    error_message = "resource_aws_appmesh_route, http_route match method must be one of: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.match.method == null || contains(["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"], var.spec.http2_route.match.method)
    )
    error_message = "resource_aws_appmesh_route, http2_route match method must be one of: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.match.scheme == null || contains(["http", "https"], var.spec.http_route.match.scheme)
    )
    error_message = "resource_aws_appmesh_route, http_route match scheme must be 'http' or 'https'."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.match.scheme == null || contains(["http", "https"], var.spec.http2_route.match.scheme)
    )
    error_message = "resource_aws_appmesh_route, http2_route match scheme must be 'http' or 'https'."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.retry_policy == null ? true : (
        (var.spec.http_route.retry_policy.http_retry_events != null && length(var.spec.http_route.retry_policy.http_retry_events) > 0) ||
        (var.spec.http_route.retry_policy.tcp_retry_events != null && length(var.spec.http_route.retry_policy.tcp_retry_events) > 0)
      )
    )
    error_message = "resource_aws_appmesh_route, http_route retry_policy must specify at least one of http_retry_events or tcp_retry_events."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.retry_policy == null ? true : (
        (var.spec.http2_route.retry_policy.http_retry_events != null && length(var.spec.http2_route.retry_policy.http_retry_events) > 0) ||
        (var.spec.http2_route.retry_policy.tcp_retry_events != null && length(var.spec.http2_route.retry_policy.tcp_retry_events) > 0)
      )
    )
    error_message = "resource_aws_appmesh_route, http2_route retry_policy must specify at least one of http_retry_events or tcp_retry_events."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.http_route.retry_policy.http_retry_events != null ? var.spec.http_route.retry_policy.http_retry_events : []) :
        contains(["client-error", "gateway-error", "server-error", "stream-error"], event)
      ])
    )
    error_message = "resource_aws_appmesh_route, http_route http_retry_events must be one of: client-error, gateway-error, server-error, stream-error."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.http2_route.retry_policy.http_retry_events != null ? var.spec.http2_route.retry_policy.http_retry_events : []) :
        contains(["client-error", "gateway-error", "server-error", "stream-error"], event)
      ])
    )
    error_message = "resource_aws_appmesh_route, http2_route http_retry_events must be one of: client-error, gateway-error, server-error, stream-error."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.http_route.retry_policy.tcp_retry_events != null ? var.spec.http_route.retry_policy.tcp_retry_events : []) :
        event == "connection-error"
      ])
    )
    error_message = "resource_aws_appmesh_route, http_route tcp_retry_events must be 'connection-error'."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.retry_policy == null ? true : alltrue([
        for event in(var.spec.http2_route.retry_policy.tcp_retry_events != null ? var.spec.http2_route.retry_policy.tcp_retry_events : []) :
        event == "connection-error"
      ])
    )
    error_message = "resource_aws_appmesh_route, http2_route tcp_retry_events must be 'connection-error'."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.retry_policy == null ? true : contains(["ms", "s"], var.spec.http_route.retry_policy.per_retry_timeout.unit)
    )
    error_message = "resource_aws_appmesh_route, http_route per_retry_timeout unit must be 'ms' or 's'."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.retry_policy == null ? true : contains(["ms", "s"], var.spec.http2_route.retry_policy.per_retry_timeout.unit)
    )
    error_message = "resource_aws_appmesh_route, http2_route per_retry_timeout unit must be 'ms' or 's'."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.timeout == null ? true : (
        var.spec.http_route.timeout.idle == null ? true : (
          contains(["ms", "s"], var.spec.http_route.timeout.idle.unit) && var.spec.http_route.timeout.idle.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, http_route timeout idle unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.timeout == null ? true : (
        var.spec.http2_route.timeout.idle == null ? true : (
          contains(["ms", "s"], var.spec.http2_route.timeout.idle.unit) && var.spec.http2_route.timeout.idle.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, http2_route timeout idle unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.http_route == null ? true : (
      var.spec.http_route.timeout == null ? true : (
        var.spec.http_route.timeout.per_request == null ? true : (
          contains(["ms", "s"], var.spec.http_route.timeout.per_request.unit) && var.spec.http_route.timeout.per_request.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, http_route timeout per_request unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.http2_route == null ? true : (
      var.spec.http2_route.timeout == null ? true : (
        var.spec.http2_route.timeout.per_request == null ? true : (
          contains(["ms", "s"], var.spec.http2_route.timeout.per_request.unit) && var.spec.http2_route.timeout.per_request.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, http2_route timeout per_request unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.http_route == null ? true : alltrue([
      for target in var.spec.http_route.action.weighted_target :
      can(regex("^.{1,255}$", target.virtual_node)) && target.weight >= 0 && target.weight <= 100
    ])
    error_message = "resource_aws_appmesh_route, http_route weighted_target virtual_node must be 1-255 characters and weight must be 0-100."
  }

  validation {
    condition = var.spec.http2_route == null ? true : alltrue([
      for target in var.spec.http2_route.action.weighted_target :
      can(regex("^.{1,255}$", target.virtual_node)) && target.weight >= 0 && target.weight <= 100
    ])
    error_message = "resource_aws_appmesh_route, http2_route weighted_target virtual_node must be 1-255 characters and weight must be 0-100."
  }

  # TCP Route validations
  validation {
    condition = var.spec.tcp_route == null ? true : (
      var.spec.tcp_route.timeout == null ? true : (
        var.spec.tcp_route.timeout.idle == null ? true : (
          contains(["ms", "s"], var.spec.tcp_route.timeout.idle.unit) && var.spec.tcp_route.timeout.idle.value >= 0
        )
      )
    )
    error_message = "resource_aws_appmesh_route, tcp_route timeout idle unit must be 'ms' or 's' and value must be >= 0."
  }

  validation {
    condition = var.spec.tcp_route == null ? true : alltrue([
      for target in var.spec.tcp_route.action.weighted_target :
      can(regex("^.{1,255}$", target.virtual_node)) && target.weight >= 0 && target.weight <= 100
    ])
    error_message = "resource_aws_appmesh_route, tcp_route weighted_target virtual_node must be 1-255 characters and weight must be 0-100."
  }
}