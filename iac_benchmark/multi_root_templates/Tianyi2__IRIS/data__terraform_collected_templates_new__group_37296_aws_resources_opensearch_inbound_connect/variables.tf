variable "connection_id" {
  description = "Specifies the ID of the connection to accept"
  type        = string

  validation {
    condition     = length(var.connection_id) > 0
    error_message = "resource_aws_opensearch_inbound_connection_accepter, connection_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_opensearch_inbound_connection_accepter, region must be a valid AWS region format."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the resource"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_opensearch_inbound_connection_accepter, create_timeout must be a valid timeout format (e.g., 5m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the resource"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_opensearch_inbound_connection_accepter, delete_timeout must be a valid timeout format (e.g., 5m, 1h)."
  }
}