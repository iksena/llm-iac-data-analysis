variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Fully-qualified domain name to register."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_api_gateway_domain_name, domain_name must not be empty."
  }
}

variable "endpoint_configuration" {
  description = "Configuration block defining API endpoint information including type."
  type = object({
    ip_address_type = optional(string)
    types           = list(string)
  })
  default = null

  validation {
    condition = var.endpoint_configuration == null || (
      var.endpoint_configuration.ip_address_type == null ||
      contains(["ipv4", "dualstack"], var.endpoint_configuration.ip_address_type)
    )
    error_message = "resource_aws_api_gateway_domain_name, endpoint_configuration.ip_address_type must be either 'ipv4' or 'dualstack'."
  }

  validation {
    condition = var.endpoint_configuration == null || (
      var.endpoint_configuration.types != null &&
      length(var.endpoint_configuration.types) > 0 &&
      alltrue([for type in var.endpoint_configuration.types : contains(["EDGE", "REGIONAL", "PRIVATE"], type)])
    )
    error_message = "resource_aws_api_gateway_domain_name, endpoint_configuration.types must be a non-empty list containing only 'EDGE', 'REGIONAL', or 'PRIVATE'."
  }
}

variable "mutual_tls_authentication" {
  description = "Mutual TLS authentication configuration for the domain name."
  type = object({
    truststore_uri     = string
    truststore_version = optional(string)
  })
  default = null

  validation {
    condition = var.mutual_tls_authentication == null || (
      var.mutual_tls_authentication.truststore_uri != null &&
      length(var.mutual_tls_authentication.truststore_uri) > 0
    )
    error_message = "resource_aws_api_gateway_domain_name, mutual_tls_authentication.truststore_uri must not be empty when mutual_tls_authentication is specified."
  }
}

variable "policy" {
  description = "A stringified JSON policy document that applies to the execute-api service for this DomainName regardless of the caller and Method configuration. Supported only for private custom domain names."
  type        = string
  default     = null
}

variable "ownership_verification_certificate_arn" {
  description = "ARN of the AWS-issued certificate used to validate custom domain ownership (when certificate_arn is issued via an ACM Private CA or mutual_tls_authentication is configured with an ACM-imported certificate.)"
  type        = string
  default     = null
}

variable "security_policy" {
  description = "Transport Layer Security (TLS) version + cipher suite for this DomainName. Valid values are TLS_1_0 and TLS_1_2. Must be configured to perform drift detection."
  type        = string
  default     = null

  validation {
    condition     = var.security_policy == null || contains(["TLS_1_0", "TLS_1_2"], var.security_policy)
    error_message = "resource_aws_api_gateway_domain_name, security_policy must be either 'TLS_1_0' or 'TLS_1_2'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "certificate_arn" {
  description = "ARN for an AWS-managed certificate. AWS Certificate Manager is the only supported source. Used when an edge-optimized domain name is desired. Conflicts with certificate_name, certificate_body, certificate_chain, certificate_private_key, regional_certificate_arn, and regional_certificate_name."
  type        = string
  default     = null

}

variable "regional_certificate_arn" {
  description = "ARN for an AWS-managed certificate. AWS Certificate Manager is the only supported source. Used when a regional domain name is desired. Conflicts with certificate_arn, certificate_name, certificate_body, certificate_chain, and certificate_private_key."
  type        = string
  default     = null

}

variable "certificate_body" {
  description = "Certificate issued for the domain name being registered, in PEM format. Only valid for EDGE endpoint configuration type. Conflicts with certificate_arn, regional_certificate_arn, and regional_certificate_name."
  type        = string
  default     = null
  sensitive   = true

}

variable "certificate_chain" {
  description = "Certificate for the CA that issued the certificate, along with any intermediate CA certificates required to create an unbroken chain to a certificate trusted by the intended API clients. Only valid for EDGE endpoint configuration type. Conflicts with certificate_arn, regional_certificate_arn, and regional_certificate_name."
  type        = string
  default     = null
  sensitive   = true

}

variable "certificate_name" {
  description = "Unique name to use when registering this certificate as an IAM server certificate. Conflicts with certificate_arn, regional_certificate_arn, and regional_certificate_name. Required if certificate_arn is not set."
  type        = string
  default     = null

}

variable "certificate_private_key" {
  description = "Private key associated with the domain certificate given in certificate_body. Only valid for EDGE endpoint configuration type. Conflicts with certificate_arn, regional_certificate_arn, and regional_certificate_name."
  type        = string
  default     = null
  sensitive   = true

}

variable "regional_certificate_name" {
  description = "User-friendly name of the certificate that will be used by regional endpoint for this domain name. Conflicts with certificate_arn, certificate_name, certificate_body, certificate_chain, and certificate_private_key."
  type        = string
  default     = null

}