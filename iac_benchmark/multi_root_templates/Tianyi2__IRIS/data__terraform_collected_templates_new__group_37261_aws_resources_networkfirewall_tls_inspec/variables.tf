variable "name" {
  description = "Descriptive name of the TLS inspection configuration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, name must not be empty."
  }
}

variable "description" {
  description = "Description of the TLS inspection configuration"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "Encryption configuration block"
  type = object({
    key_id = optional(string)
    type   = optional(string)
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration.type == null ||
      contains(["AWS_OWNED_KMS_KEY", "CUSTOMER_KMS"], var.encryption_configuration.type)
    )
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, encryption_configuration.type must be one of: AWS_OWNED_KMS_KEY, CUSTOMER_KMS."
  }
}

variable "tls_inspection_configuration" {
  description = "TLS inspection configuration block"
  type = object({
    server_certificate_configurations = list(object({
      certificate_authority_arn = optional(string)
      check_certificate_revocation_status = optional(object({
        revoked_status_action = optional(string)
        unknown_status_action = optional(string)
      }))
      server_certificates = optional(list(object({
        resource_arn = optional(string)
      })), [])
      scopes = list(object({
        protocols = optional(list(number))
        destinations = list(object({
          address_definition = string
        }))
        destination_ports = optional(list(object({
          from_port = number
          to_port   = optional(number)
        })), [])
        sources = optional(list(object({
          address_definition = string
        })), [])
        source_ports = optional(list(object({
          from_port = number
          to_port   = optional(number)
        })), [])
      }))
    }))
  })

  validation {
    condition     = length(var.tls_inspection_configuration.server_certificate_configurations) > 0
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, tls_inspection_configuration must contain at least one server_certificate_configuration."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      config.check_certificate_revocation_status == null ||
      alltrue([
        config.check_certificate_revocation_status.revoked_status_action == null || contains(["PASS", "DROP", "REJECT"], config.check_certificate_revocation_status.revoked_status_action),
        config.check_certificate_revocation_status.unknown_status_action == null || contains(["PASS", "DROP", "REJECT"], config.check_certificate_revocation_status.unknown_status_action)
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, check_certificate_revocation_status actions must be one of: PASS, DROP, REJECT."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      alltrue([
        for scope in config.scopes :
        scope.protocols == null || alltrue([
          for protocol in scope.protocols : protocol == 6
        ])
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, protocols must contain only valid protocol numbers. Currently only TCP (6) is supported."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      alltrue([
        for scope in config.scopes :
        alltrue([
          for dest_port in scope.destination_ports :
          dest_port.to_port == null || dest_port.to_port >= dest_port.from_port
        ])
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, destination_ports to_port must be greater than or equal to from_port."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      alltrue([
        for scope in config.scopes :
        alltrue([
          for src_port in scope.source_ports :
          src_port.to_port == null || src_port.to_port >= src_port.from_port
        ])
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, source_ports to_port must be greater than or equal to from_port."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      alltrue([
        for scope in config.scopes :
        alltrue([
          for dest_port in scope.destination_ports :
          dest_port.from_port >= 0 && dest_port.from_port <= 65535 &&
          (dest_port.to_port == null || (dest_port.to_port >= 0 && dest_port.to_port <= 65535))
        ])
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, destination_ports must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for config in var.tls_inspection_configuration.server_certificate_configurations :
      alltrue([
        for scope in config.scopes :
        alltrue([
          for src_port in scope.source_ports :
          src_port.from_port >= 0 && src_port.from_port <= 65535 &&
          (src_port.to_port == null || (src_port.to_port >= 0 && src_port.to_port <= 65535))
        ])
      ])
    ])
    error_message = "resource_aws_networkfirewall_tls_inspection_configuration, source_ports must be between 0 and 65535."
  }
}

variable "timeouts" {
  description = "Timeout configuration for resource operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}