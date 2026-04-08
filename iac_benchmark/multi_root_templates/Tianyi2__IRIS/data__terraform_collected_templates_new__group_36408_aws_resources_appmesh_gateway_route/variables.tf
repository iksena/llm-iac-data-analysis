variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the gateway route"
  type        = string
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_gateway_route, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which to create the gateway route"
  type        = string
  validation {
    condition     = length(var.mesh_name) >= 1 && length(var.mesh_name) <= 255
    error_message = "resource_aws_appmesh_gateway_route, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "virtual_gateway_name" {
  description = "Name of the virtual gateway to associate the gateway route with"
  type        = string
  validation {
    condition     = length(var.virtual_gateway_name) >= 1 && length(var.virtual_gateway_name) <= 255
    error_message = "resource_aws_appmesh_gateway_route, virtual_gateway_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "spec_priority" {
  description = "Priority for the gateway route"
  type        = number
  default     = null
  validation {
    condition     = var.spec_priority == null || (var.spec_priority >= 0 && var.spec_priority <= 1000)
    error_message = "resource_aws_appmesh_gateway_route, spec_priority must be between 0 and 1000."
  }
}

variable "grpc_route" {
  description = "Specification of a gRPC gateway route"
  type = object({
    action = object({
      target = object({
        port = optional(number)
        virtual_service = object({
          virtual_service_name = string
        })
      })
    })
    match = object({
      service_name = string
      port         = optional(number)
    })
  })
  default = null

  validation {
    condition = var.grpc_route == null || (
      var.grpc_route.action.target.virtual_service.virtual_service_name != null &&
      length(var.grpc_route.action.target.virtual_service.virtual_service_name) >= 1 &&
      length(var.grpc_route.action.target.virtual_service.virtual_service_name) <= 255
    )
    error_message = "resource_aws_appmesh_gateway_route, grpc_route virtual_service_name must be between 1 and 255 characters in length."
  }
}

variable "http_route" {
  description = "Specification of an HTTP gateway route"
  type = object({
    action = object({
      target = object({
        port = optional(number)
        virtual_service = object({
          virtual_service_name = string
        })
      })
      rewrite = optional(object({
        hostname = optional(object({
          default_target_hostname = string
        }))
        path = optional(object({
          exact = string
        }))
        prefix = optional(object({
          default_prefix = optional(string)
          value          = optional(string)
        }))
      }))
    })
    match = object({
      port   = optional(number)
      prefix = optional(string)
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
      hostname = optional(object({
        exact  = optional(string)
        suffix = optional(string)
      }))
      path = optional(object({
        exact = optional(string)
        regex = optional(string)
      }))
      query_parameter = optional(list(object({
        name = string
        match = optional(object({
          exact = optional(string)
        }))
      })))
    })
  })
  default = null

  validation {
    condition = var.http_route == null || (
      var.http_route.action.target.virtual_service.virtual_service_name != null &&
      length(var.http_route.action.target.virtual_service.virtual_service_name) >= 1 &&
      length(var.http_route.action.target.virtual_service.virtual_service_name) <= 255
    )
    error_message = "resource_aws_appmesh_gateway_route, http_route virtual_service_name must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.http_route == null || var.http_route.action.rewrite == null || var.http_route.action.rewrite.hostname == null || (
      var.http_route.action.rewrite.hostname.default_target_hostname == "ENABLED" ||
      var.http_route.action.rewrite.hostname.default_target_hostname == "DISABLED"
    )
    error_message = "resource_aws_appmesh_gateway_route, http_route rewrite hostname default_target_hostname must be ENABLED or DISABLED."
  }

  validation {
    condition = var.http_route == null || var.http_route.action.rewrite == null || var.http_route.action.rewrite.prefix == null || var.http_route.action.rewrite.prefix.default_prefix == null || (
      var.http_route.action.rewrite.prefix.default_prefix == "ENABLED" ||
      var.http_route.action.rewrite.prefix.default_prefix == "DISABLED"
    )
    error_message = "resource_aws_appmesh_gateway_route, http_route rewrite prefix default_prefix must be ENABLED or DISABLED."
  }

  validation {
    condition     = var.http_route == null || var.http_route.match.prefix == null || can(regex("^/", var.http_route.match.prefix))
    error_message = "resource_aws_appmesh_gateway_route, http_route match prefix must always start with /."
  }
}

variable "http2_route" {
  description = "Specification of an HTTP/2 gateway route"
  type = object({
    action = object({
      target = object({
        port = optional(number)
        virtual_service = object({
          virtual_service_name = string
        })
      })
      rewrite = optional(object({
        hostname = optional(object({
          default_target_hostname = string
        }))
        path = optional(object({
          exact = string
        }))
        prefix = optional(object({
          default_prefix = optional(string)
          value          = optional(string)
        }))
      }))
    })
    match = object({
      port   = optional(number)
      prefix = optional(string)
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
      hostname = optional(object({
        exact  = optional(string)
        suffix = optional(string)
      }))
      path = optional(object({
        exact = optional(string)
        regex = optional(string)
      }))
      query_parameter = optional(list(object({
        name = string
        match = optional(object({
          exact = optional(string)
        }))
      })))
    })
  })
  default = null

  validation {
    condition = var.http2_route == null || (
      var.http2_route.action.target.virtual_service.virtual_service_name != null &&
      length(var.http2_route.action.target.virtual_service.virtual_service_name) >= 1 &&
      length(var.http2_route.action.target.virtual_service.virtual_service_name) <= 255
    )
    error_message = "resource_aws_appmesh_gateway_route, http2_route virtual_service_name must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.http2_route == null || var.http2_route.action.rewrite == null || var.http2_route.action.rewrite.hostname == null || (
      var.http2_route.action.rewrite.hostname.default_target_hostname == "ENABLED" ||
      var.http2_route.action.rewrite.hostname.default_target_hostname == "DISABLED"
    )
    error_message = "resource_aws_appmesh_gateway_route, http2_route rewrite hostname default_target_hostname must be ENABLED or DISABLED."
  }

  validation {
    condition = var.http2_route == null || var.http2_route.action.rewrite == null || var.http2_route.action.rewrite.prefix == null || var.http2_route.action.rewrite.prefix.default_prefix == null || (
      var.http2_route.action.rewrite.prefix.default_prefix == "ENABLED" ||
      var.http2_route.action.rewrite.prefix.default_prefix == "DISABLED"
    )
    error_message = "resource_aws_appmesh_gateway_route, http2_route rewrite prefix default_prefix must be ENABLED or DISABLED."
  }

  validation {
    condition     = var.http2_route == null || var.http2_route.match.prefix == null || can(regex("^/", var.http2_route.match.prefix))
    error_message = "resource_aws_appmesh_gateway_route, http2_route match prefix must always start with /."
  }
}