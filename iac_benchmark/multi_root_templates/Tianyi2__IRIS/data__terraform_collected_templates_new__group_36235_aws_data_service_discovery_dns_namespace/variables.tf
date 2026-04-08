variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the namespace."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_service_discovery_dns_namespace, name must not be empty."
  }
}

variable "type" {
  type        = string
  description = "Type of the namespace. Allowed values are DNS_PUBLIC or DNS_PRIVATE."

  validation {
    condition     = contains(["DNS_PUBLIC", "DNS_PRIVATE"], var.type)
    error_message = "data_aws_service_discovery_dns_namespace, type must be either 'DNS_PUBLIC' or 'DNS_PRIVATE'."
  }
}