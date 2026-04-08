variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "directory_id" {
  description = "ID of directory."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.directory_id))
    error_message = "resource_aws_directory_service_conditional_forwarder, directory_id must be a valid directory ID format (d-xxxxxxxxxx)."
  }
}

variable "dns_ips" {
  description = "A list of forwarder IP addresses."
  type        = list(string)

  validation {
    condition = length(var.dns_ips) > 0 && length(var.dns_ips) <= 5 && alltrue([
      for ip in var.dns_ips : can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", ip))
    ])
    error_message = "resource_aws_directory_service_conditional_forwarder, dns_ips must be a list of 1-5 valid IPv4 addresses."
  }
}

variable "remote_domain_name" {
  description = "The fully qualified domain name of the remote domain for which forwarders will be used."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*$", var.remote_domain_name))
    error_message = "resource_aws_directory_service_conditional_forwarder, remote_domain_name must be a valid fully qualified domain name."
  }
}