variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "connection_id" {
  description = "The ID of the connection."
  type        = string

  validation {
    condition     = can(regex("^dxcon-[a-z0-9]+$", var.connection_id))
    error_message = "resource_aws_dx_connection_association, connection_id must be a valid Direct Connect connection ID starting with 'dxcon-'."
  }
}

variable "lag_id" {
  description = "The ID of the LAG with which to associate the connection."
  type        = string

  validation {
    condition     = can(regex("^dxlag-[a-z0-9]+$", var.lag_id))
    error_message = "resource_aws_dx_connection_association, lag_id must be a valid Direct Connect LAG ID starting with 'dxlag-'."
  }
}