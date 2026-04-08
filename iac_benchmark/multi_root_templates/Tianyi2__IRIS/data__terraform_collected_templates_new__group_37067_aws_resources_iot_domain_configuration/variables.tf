variable "name" {
  description = "The name of the domain configuration. This value must be unique to a region."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_protocol" {
  description = "An enumerated string that specifies the application-layer protocol."
  type        = string
  default     = null
  validation {
    condition = var.application_protocol == null || contains([
      "SECURE_MQTT",
      "MQTT_WSS",
      "HTTPS",
      "DEFAULT"
    ], var.application_protocol)
    error_message = "resource_aws_iot_domain_configuration, application_protocol must be one of: SECURE_MQTT, MQTT_WSS, HTTPS, DEFAULT."
  }
}

variable "authentication_type" {
  description = "An enumerated string that specifies the authentication type."
  type        = string
  default     = null
  validation {
    condition = var.authentication_type == null || contains([
      "CUSTOM_AUTH_X509",
      "CUSTOM_AUTH",
      "AWS_X509",
      "AWS_SIGV4",
      "DEFAULT"
    ], var.authentication_type)
    error_message = "resource_aws_iot_domain_configuration, authentication_type must be one of: CUSTOM_AUTH_X509, CUSTOM_AUTH, AWS_X509, AWS_SIGV4, DEFAULT."
  }
}

variable "authorizer_config" {
  description = "An object that specifies the authorization service for a domain."
  type = object({
    allow_authorizer_override = optional(bool)
    default_authorizer_name   = optional(string)
  })
  default = null
}

variable "domain_name" {
  description = "Fully-qualified domain name."
  type        = string
  default     = null
}

variable "server_certificate_arns" {
  description = "The ARNs of the certificates that IoT passes to the device during the TLS handshake."
  type        = list(string)
  default     = null
}

variable "service_type" {
  description = "The type of service delivered by the endpoint."
  type        = string
  default     = null
  validation {
    condition = var.service_type == null || contains([
      "DATA"
    ], var.service_type)
    error_message = "resource_aws_iot_domain_configuration, service_type must be: DATA."
  }
}

variable "status" {
  description = "The status to which the domain configuration should be set."
  type        = string
  default     = null
  validation {
    condition = var.status == null || contains([
      "ENABLED",
      "DISABLED"
    ], var.status)
    error_message = "resource_aws_iot_domain_configuration, status must be one of: ENABLED, DISABLED."
  }
}

variable "tags" {
  description = "Map of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "tls_config" {
  description = "An object that specifies the TLS configuration for a domain."
  type = object({
    security_policy = optional(string)
  })
  default = null
}

variable "validation_certificate_arn" {
  description = "The certificate used to validate the server certificate and prove domain name ownership."
  type        = string
  default     = null
}