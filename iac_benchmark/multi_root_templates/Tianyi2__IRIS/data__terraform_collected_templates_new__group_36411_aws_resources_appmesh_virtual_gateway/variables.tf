variable "name" {
  type        = string
  description = "Name to use for the virtual gateway."

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_virtual_gateway, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  type        = string
  description = "Name of the service mesh in which to create the virtual gateway."

  validation {
    condition     = length(var.mesh_name) >= 1 && length(var.mesh_name) <= 255
    error_message = "resource_aws_appmesh_virtual_gateway, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  type        = string
  description = "AWS account ID of the service mesh's owner."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed."
  default     = null
}

variable "spec" {
  type = object({
    listener = object({
      port_mapping = object({
        port     = number
        protocol = string
      })
      connection_pool = optional(object({
        grpc = optional(object({
          max_requests = number
        }))
        http = optional(object({
          max_connections      = number
          max_pending_requests = optional(number)
        }))
        http2 = optional(object({
          max_requests = number
        }))
      }))
      health_check = optional(object({
        healthy_threshold   = number
        interval_millis     = number
        protocol            = string
        timeout_millis      = number
        unhealthy_threshold = number
        path                = optional(string)
        port                = optional(number)
      }))
      tls = optional(object({
        certificate = object({
          acm = optional(object({
            certificate_arn = string
          }))
          file = optional(object({
            certificate_chain = string
            private_key       = string
          }))
          sds = optional(object({
            secret_name = string
          }))
        })
        mode = string
        validation = optional(object({
          subject_alternative_names = optional(object({
            match = object({
              exact = list(string)
            })
          }))
          trust = object({
            file = optional(object({
              certificate_chain = string
            }))
            sds = optional(object({
              secret_name = string
            }))
          })
        }))
      }))
    })
    backend_defaults = optional(object({
      client_policy = optional(object({
        tls = optional(object({
          certificate = optional(object({
            file = optional(object({
              certificate_chain = string
              private_key       = string
            }))
            sds = optional(object({
              secret_name = string
            }))
          }))
          enforce = optional(bool)
          ports   = optional(list(number))
          validation = object({
            subject_alternative_names = optional(object({
              match = object({
                exact = list(string)
              })
            }))
            trust = object({
              acm = optional(object({
                certificate_authority_arns = list(string)
              }))
              file = optional(object({
                certificate_chain = string
              }))
              sds = optional(object({
                secret_name = string
              }))
            })
          })
        }))
      }))
    }))
    logging = optional(object({
      access_log = optional(object({
        file = optional(object({
          format = optional(object({
            json = optional(list(object({
              key   = string
              value = string
            })))
            text = optional(string)
          }))
          path = string
        }))
      }))
    }))
  })
  description = "Virtual gateway specification to apply."

  validation {
    condition     = contains(["http", "http2", "tcp", "grpc"], var.spec.listener.port_mapping.protocol)
    error_message = "resource_aws_appmesh_virtual_gateway, protocol must be one of http, http2, tcp, or grpc."
  }

  validation {
    condition     = var.spec.listener.health_check == null || contains(["http", "http2", "grpc"], var.spec.listener.health_check.protocol)
    error_message = "resource_aws_appmesh_virtual_gateway, health_check.protocol must be one of http, http2, or grpc."
  }

  validation {
    condition     = var.spec.listener.tls == null || contains(["DISABLED", "PERMISSIVE", "STRICT"], var.spec.listener.tls.mode)
    error_message = "resource_aws_appmesh_virtual_gateway, tls.mode must be one of DISABLED, PERMISSIVE, or STRICT."
  }

  validation {
    condition     = var.spec.listener.connection_pool == null || var.spec.listener.connection_pool.grpc == null || var.spec.listener.connection_pool.grpc.max_requests >= 1
    error_message = "resource_aws_appmesh_virtual_gateway, connection_pool.grpc.max_requests must have a minimum value of 1."
  }

  validation {
    condition     = var.spec.listener.connection_pool == null || var.spec.listener.connection_pool.http == null || var.spec.listener.connection_pool.http.max_connections >= 1
    error_message = "resource_aws_appmesh_virtual_gateway, connection_pool.http.max_connections must have a minimum value of 1."
  }

  validation {
    condition     = var.spec.listener.connection_pool == null || var.spec.listener.connection_pool.http == null || var.spec.listener.connection_pool.http.max_pending_requests == null || var.spec.listener.connection_pool.http.max_pending_requests >= 1
    error_message = "resource_aws_appmesh_virtual_gateway, connection_pool.http.max_pending_requests must have a minimum value of 1."
  }

  validation {
    condition     = var.spec.listener.connection_pool == null || var.spec.listener.connection_pool.http2 == null || var.spec.listener.connection_pool.http2.max_requests >= 1
    error_message = "resource_aws_appmesh_virtual_gateway, connection_pool.http2.max_requests must have a minimum value of 1."
  }

  validation {
    condition     = var.spec.listener.tls == null || var.spec.listener.tls.certificate.file == null || (length(var.spec.listener.tls.certificate.file.certificate_chain) >= 1 && length(var.spec.listener.tls.certificate.file.certificate_chain) <= 255)
    error_message = "resource_aws_appmesh_virtual_gateway, tls.certificate.file.certificate_chain must be between 1 and 255 characters in length."
  }

  validation {
    condition     = var.spec.listener.tls == null || var.spec.listener.tls.certificate.file == null || (length(var.spec.listener.tls.certificate.file.private_key) >= 1 && length(var.spec.listener.tls.certificate.file.private_key) <= 255)
    error_message = "resource_aws_appmesh_virtual_gateway, tls.certificate.file.private_key must be between 1 and 255 characters in length."
  }

  validation {
    condition     = var.spec.listener.tls == null || var.spec.listener.tls.validation == null || var.spec.listener.tls.validation.trust.file == null || (length(var.spec.listener.tls.validation.trust.file.certificate_chain) >= 1 && length(var.spec.listener.tls.validation.trust.file.certificate_chain) <= 255)
    error_message = "resource_aws_appmesh_virtual_gateway, tls.validation.trust.file.certificate_chain must be between 1 and 255 characters in length."
  }

  validation {
    condition     = var.spec.backend_defaults == null || var.spec.backend_defaults.client_policy == null || var.spec.backend_defaults.client_policy.tls == null || var.spec.backend_defaults.client_policy.tls.validation.trust.file == null || (length(var.spec.backend_defaults.client_policy.tls.validation.trust.file.certificate_chain) >= 1 && length(var.spec.backend_defaults.client_policy.tls.validation.trust.file.certificate_chain) <= 255)
    error_message = "resource_aws_appmesh_virtual_gateway, backend_defaults.client_policy.tls.validation.trust.file.certificate_chain must be between 1 and 255 characters in length."
  }

  validation {
    condition     = var.spec.logging == null || var.spec.logging.access_log == null || var.spec.logging.access_log.file == null || (length(var.spec.logging.access_log.file.path) >= 1 && length(var.spec.logging.access_log.file.path) <= 255)
    error_message = "resource_aws_appmesh_virtual_gateway, logging.access_log.file.path must be between 1 and 255 characters in length."
  }

  validation {
    condition     = var.spec.logging == null || var.spec.logging.access_log == null || var.spec.logging.access_log.file == null || var.spec.logging.access_log.file.format == null || var.spec.logging.access_log.file.format.text == null || (length(var.spec.logging.access_log.file.format.text) >= 1 && length(var.spec.logging.access_log.file.format.text) <= 1000)
    error_message = "resource_aws_appmesh_virtual_gateway, logging.access_log.file.format.text must be between 1 and 1000 characters in length."
  }

  validation {
    condition     = var.spec.logging == null || var.spec.logging.access_log == null || var.spec.logging.access_log.file == null || var.spec.logging.access_log.file.format == null || var.spec.logging.access_log.file.format.json == null || length([for item in var.spec.logging.access_log.file.format.json : true if length(item.key) >= 1 && length(item.key) <= 100]) == length(var.spec.logging.access_log.file.format.json)
    error_message = "resource_aws_appmesh_virtual_gateway, logging.access_log.file.format.json.key must be between 1 and 100 characters in length."
  }

  validation {
    condition     = var.spec.logging == null || var.spec.logging.access_log == null || var.spec.logging.access_log.file == null || var.spec.logging.access_log.file.format == null || var.spec.logging.access_log.file.format.json == null || length([for item in var.spec.logging.access_log.file.format.json : true if length(item.value) >= 1 && length(item.value) <= 100]) == length(var.spec.logging.access_log.file.format.json)
    error_message = "resource_aws_appmesh_virtual_gateway, logging.access_log.file.format.json.value must be between 1 and 100 characters in length."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
  default     = {}
}