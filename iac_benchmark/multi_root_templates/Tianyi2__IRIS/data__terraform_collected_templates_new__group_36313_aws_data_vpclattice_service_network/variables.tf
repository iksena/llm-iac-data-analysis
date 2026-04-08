variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "service_network_identifier" {
  description = "Identifier of the service network."
  type        = string

  validation {
    condition     = length(var.service_network_identifier) > 0
    error_message = "data_aws_vpclattice_service_network, service_network_identifier must not be empty."
  }
}