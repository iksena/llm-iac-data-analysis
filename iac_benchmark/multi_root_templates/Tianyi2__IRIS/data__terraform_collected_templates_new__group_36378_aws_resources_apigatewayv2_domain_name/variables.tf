variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name. Must be between 1 and 512 characters in length."
  type        = string

  validation {
    condition     = length(var.domain_name) >= 1 && length(var.domain_name) <= 512
    error_message = "resource_aws_apigatewayv2_domain_name, domain_name must be between 1 and 512 characters in length."
  }
}

variable "domain_name_configuration" {
  description = "Domain name configuration."
  type = object({
    certificate_arn                        = string
    endpoint_type                          = string
    ip_address_type                        = optional(string, "ipv4")
    ownership_verification_certificate_arn = optional(string)
    security_policy                        = string
  })

  validation {
    condition     = contains(["REGIONAL"], var.domain_name_configuration.endpoint_type)
    error_message = "resource_aws_apigatewayv2_domain_name, endpoint_type must be one of: REGIONAL."
  }

  validation {
    condition     = contains(["ipv4", "dualstack"], var.domain_name_configuration.ip_address_type)
    error_message = "resource_aws_apigatewayv2_domain_name, ip_address_type must be one of: ipv4, dualstack."
  }

  validation {
    condition     = contains(["TLS_1_2"], var.domain_name_configuration.security_policy)
    error_message = "resource_aws_apigatewayv2_domain_name, security_policy must be one of: TLS_1_2."
  }
}

variable "mutual_tls_authentication" {
  description = "Mutual TLS authentication configuration for the domain name."
  type = object({
    truststore_uri     = string
    truststore_version = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Map of tags to assign to the domain name."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration for create and update operations."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "60m")
  })
  default = {
    create = "10m"
    update = "60m"
  }
}