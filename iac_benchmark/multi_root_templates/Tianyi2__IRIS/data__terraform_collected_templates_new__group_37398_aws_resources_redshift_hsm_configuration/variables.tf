variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A text description of the HSM configuration to be created."
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_redshift_hsm_configuration, description cannot be empty."
  }
}

variable "hsm_configuration_identifier" {
  description = "The identifier to be assigned to the new Amazon Redshift HSM configuration."
  type        = string

  validation {
    condition     = length(var.hsm_configuration_identifier) > 0
    error_message = "resource_aws_redshift_hsm_configuration, hsm_configuration_identifier cannot be empty."
  }
}

variable "hsm_ip_address" {
  description = "The IP address that the Amazon Redshift cluster must use to access the HSM."
  type        = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.hsm_ip_address))
    error_message = "resource_aws_redshift_hsm_configuration, hsm_ip_address must be a valid IPv4 address."
  }
}

variable "hsm_partition_name" {
  description = "The name of the partition in the HSM where the Amazon Redshift clusters will store their database encryption keys."
  type        = string

  validation {
    condition     = length(var.hsm_partition_name) > 0
    error_message = "resource_aws_redshift_hsm_configuration, hsm_partition_name cannot be empty."
  }
}

variable "hsm_partition_password" {
  description = "The password required to access the HSM partition."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.hsm_partition_password) > 0
    error_message = "resource_aws_redshift_hsm_configuration, hsm_partition_password cannot be empty."
  }
}

variable "hsm_server_public_certificate" {
  description = "The HSMs public certificate file. When using Cloud HSM, the file name is server.pem."
  type        = string

  validation {
    condition     = length(var.hsm_server_public_certificate) > 0
    error_message = "resource_aws_redshift_hsm_configuration, hsm_server_public_certificate cannot be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}