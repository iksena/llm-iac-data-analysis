variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the virtual node. Must be between 1 and 255 characters in length."
  type        = string
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_virtual_node, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which to create the virtual node. Must be between 1 and 255 characters in length."
  type        = string
  validation {
    condition     = length(var.mesh_name) >= 1 && length(var.mesh_name) <= 255
    error_message = "resource_aws_appmesh_virtual_node, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner. Defaults to the account ID the AWS provider is currently connected to."
  type        = string
  default     = null
}

variable "spec" {
  description = "Virtual node specification to apply."
  type = object({
    backend = optional(list(object({
      virtual_service = object({
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
            enforce = optional(bool, true)
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
        virtual_service_name = string
      })
    })), [])
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
          enforce = optional(bool, true)
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
    listener = optional(list(object({
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
        tcp = optional(object({
          max_connections = number
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
      outlier_detection = optional(object({
        base_ejection_duration = object({
          unit  = string
          value = number
        })
        interval = object({
          unit  = string
          value = number
        })
        max_ejection_percent = number
        max_server_errors    = number
      }))
      timeout = optional(object({
        grpc = optional(object({
          idle = optional(object({
            unit  = string
            value = number
          }))
          per_request = optional(object({
            unit  = string
            value = number
          }))
        }))
        http = optional(object({
          idle = optional(object({
            unit  = string
            value = number
          }))
          per_request = optional(object({
            unit  = string
            value = number
          }))
        }))
        http2 = optional(object({
          idle = optional(object({
            unit  = string
            value = number
          }))
          per_request = optional(object({
            unit  = string
            value = number
          }))
        }))
        tcp = optional(object({
          idle = optional(object({
            unit  = string
            value = number
          }))
        }))
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
    })), [])
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
    service_discovery = optional(object({
      aws_cloud_map = optional(object({
        attributes     = optional(map(string))
        namespace_name = string
        service_name   = string
      }))
      dns = optional(object({
        hostname      = string
        ip_preference = optional(string)
        response_type = optional(string)
      }))
    }))
  })

  validation {
    condition = var.spec.backend == null || alltrue([
      for backend in var.spec.backend :
      length(backend.virtual_service.virtual_service_name) >= 1 && length(backend.virtual_service.virtual_service_name) <= 255
    ])
    error_message = "resource_aws_appmesh_virtual_node, virtual_service_name must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec.backend == null || alltrue([
      for backend in var.spec.backend :
      backend.virtual_service.client_policy == null ||
      backend.virtual_service.client_policy.tls == null ||
      backend.virtual_service.client_policy.tls.certificate == null ||
      backend.virtual_service.client_policy.tls.certificate.file == null ||
      (length(backend.virtual_service.client_policy.tls.certificate.file.certificate_chain) >= 1 && length(backend.virtual_service.client_policy.tls.certificate.file.certificate_chain) <= 255 &&
      length(backend.virtual_service.client_policy.tls.certificate.file.private_key) >= 1 && length(backend.virtual_service.client_policy.tls.certificate.file.private_key) <= 255)
    ])
    error_message = "resource_aws_appmesh_virtual_node, certificate_chain and private_key must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec.backend == null || alltrue([
      for backend in var.spec.backend :
      backend.virtual_service.client_policy == null ||
      backend.virtual_service.client_policy.tls == null ||
      backend.virtual_service.client_policy.tls.validation == null ||
      backend.virtual_service.client_policy.tls.validation.trust == null ||
      backend.virtual_service.client_policy.tls.validation.trust.file == null ||
      (length(backend.virtual_service.client_policy.tls.validation.trust.file.certificate_chain) >= 1 && length(backend.virtual_service.client_policy.tls.validation.trust.file.certificate_chain) <= 255)
    ])
    error_message = "resource_aws_appmesh_virtual_node, certificate_chain must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      contains(["http", "http2", "tcp", "grpc"], listener.port_mapping.protocol)
    ])
    error_message = "resource_aws_appmesh_virtual_node, protocol must be one of: http, http2, tcp, grpc."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.connection_pool == null ||
      listener.connection_pool.grpc == null ||
      listener.connection_pool.grpc.max_requests >= 1
    ])
    error_message = "resource_aws_appmesh_virtual_node, max_requests must have a minimum value of 1."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.connection_pool == null ||
      listener.connection_pool.http == null ||
      (listener.connection_pool.http.max_connections >= 1 &&
      (listener.connection_pool.http.max_pending_requests == null || listener.connection_pool.http.max_pending_requests >= 1))
    ])
    error_message = "resource_aws_appmesh_virtual_node, max_connections and max_pending_requests must have a minimum value of 1."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.connection_pool == null ||
      listener.connection_pool.http2 == null ||
      listener.connection_pool.http2.max_requests >= 1
    ])
    error_message = "resource_aws_appmesh_virtual_node, max_requests must have a minimum value of 1."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.connection_pool == null ||
      listener.connection_pool.tcp == null ||
      listener.connection_pool.tcp.max_connections >= 1
    ])
    error_message = "resource_aws_appmesh_virtual_node, max_connections must have a minimum value of 1."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.health_check == null ||
      contains(["http", "http2", "tcp", "grpc"], listener.health_check.protocol)
    ])
    error_message = "resource_aws_appmesh_virtual_node, health_check protocol must be one of: http, http2, tcp, grpc."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.outlier_detection == null ||
      (contains(["ms", "s"], listener.outlier_detection.base_ejection_duration.unit) &&
        listener.outlier_detection.base_ejection_duration.value >= 0 &&
        contains(["ms", "s"], listener.outlier_detection.interval.unit) &&
        listener.outlier_detection.interval.value >= 0 &&
        listener.outlier_detection.max_ejection_percent >= 0 &&
        listener.outlier_detection.max_ejection_percent <= 100 &&
      listener.outlier_detection.max_server_errors >= 1)
    ])
    error_message = "resource_aws_appmesh_virtual_node, outlier_detection validation failed - check unit values (ms/s), value >= 0, max_ejection_percent (0-100), max_server_errors >= 1."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.timeout == null ||
      listener.timeout.grpc == null ||
      (listener.timeout.grpc.idle == null || (contains(["ms", "s"], listener.timeout.grpc.idle.unit) && listener.timeout.grpc.idle.value >= 0)) &&
      (listener.timeout.grpc.per_request == null || (contains(["ms", "s"], listener.timeout.grpc.per_request.unit) && listener.timeout.grpc.per_request.value >= 0))
    ])
    error_message = "resource_aws_appmesh_virtual_node, timeout unit must be ms or s, and value >= 0."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.timeout == null ||
      listener.timeout.http == null ||
      (listener.timeout.http.idle == null || (contains(["ms", "s"], listener.timeout.http.idle.unit) && listener.timeout.http.idle.value >= 0)) &&
      (listener.timeout.http.per_request == null || (contains(["ms", "s"], listener.timeout.http.per_request.unit) && listener.timeout.http.per_request.value >= 0))
    ])
    error_message = "resource_aws_appmesh_virtual_node, timeout unit must be ms or s, and value >= 0."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.timeout == null ||
      listener.timeout.http2 == null ||
      (listener.timeout.http2.idle == null || (contains(["ms", "s"], listener.timeout.http2.idle.unit) && listener.timeout.http2.idle.value >= 0)) &&
      (listener.timeout.http2.per_request == null || (contains(["ms", "s"], listener.timeout.http2.per_request.unit) && listener.timeout.http2.per_request.value >= 0))
    ])
    error_message = "resource_aws_appmesh_virtual_node, timeout unit must be ms or s, and value >= 0."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.timeout == null ||
      listener.timeout.tcp == null ||
      (listener.timeout.tcp.idle == null || (contains(["ms", "s"], listener.timeout.tcp.idle.unit) && listener.timeout.tcp.idle.value >= 0))
    ])
    error_message = "resource_aws_appmesh_virtual_node, timeout unit must be ms or s, and value >= 0."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.tls == null ||
      contains(["DISABLED", "PERMISSIVE", "STRICT"], listener.tls.mode)
    ])
    error_message = "resource_aws_appmesh_virtual_node, tls mode must be one of: DISABLED, PERMISSIVE, STRICT."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.tls == null ||
      listener.tls.certificate == null ||
      listener.tls.certificate.file == null ||
      (length(listener.tls.certificate.file.certificate_chain) >= 1 && length(listener.tls.certificate.file.certificate_chain) <= 255 &&
      length(listener.tls.certificate.file.private_key) >= 1 && length(listener.tls.certificate.file.private_key) <= 255)
    ])
    error_message = "resource_aws_appmesh_virtual_node, certificate_chain and private_key must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec.listener == null || alltrue([
      for listener in var.spec.listener :
      listener.tls == null ||
      listener.tls.validation == null ||
      listener.tls.validation.trust == null ||
      listener.tls.validation.trust.file == null ||
      (length(listener.tls.validation.trust.file.certificate_chain) >= 1 && length(listener.tls.validation.trust.file.certificate_chain) <= 255)
    ])
    error_message = "resource_aws_appmesh_virtual_node, certificate_chain must be between 1 and 255 characters in length."
  }

  validation {
    condition = (var.spec.logging == null ||
      var.spec.logging.access_log == null ||
      var.spec.logging.access_log.file == null ||
    (length(var.spec.logging.access_log.file.path) >= 1 && length(var.spec.logging.access_log.file.path) <= 255))
    error_message = "resource_aws_appmesh_virtual_node, access_log file path must be between 1 and 255 characters in length."
  }

  validation {
    condition = (var.spec.logging == null ||
      var.spec.logging.access_log == null ||
      var.spec.logging.access_log.file == null ||
      var.spec.logging.access_log.file.format == null ||
      var.spec.logging.access_log.file.format.text == null ||
    (length(var.spec.logging.access_log.file.format.text) >= 1 && length(var.spec.logging.access_log.file.format.text) <= 1000))
    error_message = "resource_aws_appmesh_virtual_node, access_log format text must be between 1 and 1000 characters in length."
  }

  validation {
    condition = (var.spec.logging == null ||
      var.spec.logging.access_log == null ||
      var.spec.logging.access_log.file == null ||
      var.spec.logging.access_log.file.format == null ||
      var.spec.logging.access_log.file.format.json == null ||
      alltrue([
        for json_item in var.spec.logging.access_log.file.format.json :
        length(json_item.key) >= 1 && length(json_item.key) <= 100 &&
        length(json_item.value) >= 1 && length(json_item.value) <= 100
    ]))
    error_message = "resource_aws_appmesh_virtual_node, access_log format json key and value must be between 1 and 100 characters in length."
  }

  validation {
    condition = (var.spec.service_discovery == null ||
      var.spec.service_discovery.aws_cloud_map == null ||
      (length(var.spec.service_discovery.aws_cloud_map.namespace_name) >= 1 && length(var.spec.service_discovery.aws_cloud_map.namespace_name) <= 1024 &&
    length(var.spec.service_discovery.aws_cloud_map.service_name) >= 1 && length(var.spec.service_discovery.aws_cloud_map.service_name) <= 1024))
    error_message = "resource_aws_appmesh_virtual_node, aws_cloud_map namespace_name and service_name must be between 1 and 1024 characters in length."
  }

  validation {
    condition = (var.spec.service_discovery == null ||
      var.spec.service_discovery.dns == null ||
      var.spec.service_discovery.dns.ip_preference == null ||
    contains(["IPv6_PREFERRED", "IPv4_PREFERRED", "IPv4_ONLY", "IPv6_ONLY"], var.spec.service_discovery.dns.ip_preference))
    error_message = "resource_aws_appmesh_virtual_node, dns ip_preference must be one of: IPv6_PREFERRED, IPv4_PREFERRED, IPv4_ONLY, IPv6_ONLY."
  }

  validation {
    condition = (var.spec.service_discovery == null ||
      var.spec.service_discovery.dns == null ||
      var.spec.service_discovery.dns.response_type == null ||
    contains(["LOADBALANCER", "ENDPOINTS"], var.spec.service_discovery.dns.response_type))
    error_message = "resource_aws_appmesh_virtual_node, dns response_type must be one of: LOADBALANCER, ENDPOINTS."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}