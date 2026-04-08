variable "connection_id" {
  description = "The ID of the hosted connection"
  type        = string

  validation {
    condition     = can(regex("^dxcon-[a-z0-9]{8}$", var.connection_id))
    error_message = "resource_aws_dx_connection_confirmation, connection_id must be a valid Direct Connect connection ID in the format 'dxcon-xxxxxxxx' where x is a lowercase alphanumeric character."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_dx_connection_confirmation, region must be a valid AWS region format (e.g., 'us-east-1', 'eu-west-1') or null to use provider default."
  }
}