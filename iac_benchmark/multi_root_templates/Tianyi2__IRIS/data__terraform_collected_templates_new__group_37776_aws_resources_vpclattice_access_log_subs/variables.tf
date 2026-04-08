variable "destination_arn" {
  description = "Amazon Resource Name (ARN) of the log destination"
  type        = string

  validation {
    condition     = can(regex("^arn:aws", var.destination_arn))
    error_message = "resource_aws_vpclattice_access_log_subscription, destination_arn must be a valid AWS ARN starting with 'arn:aws'"
  }
}

variable "resource_identifier" {
  description = "The ID or Amazon Resource Identifier (ARN) of the service network or service. You must use the ARN if the resources specified in the operation are in different accounts"
  type        = string

  validation {
    condition     = length(var.resource_identifier) > 0
    error_message = "resource_aws_vpclattice_access_log_subscription, resource_identifier cannot be empty"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "service_network_log_type" {
  description = "Type of log that monitors your Amazon VPC Lattice service networks. Valid values are: SERVICE, RESOURCE. Defaults to SERVICE"
  type        = string
  default     = "SERVICE"

  validation {
    condition     = var.service_network_log_type == null || contains(["SERVICE", "RESOURCE"], var.service_network_log_type)
    error_message = "resource_aws_vpclattice_access_log_subscription, service_network_log_type must be either 'SERVICE' or 'RESOURCE'"
  }
}