variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The subnet ID to create an association. Conflicts with gateway_id."
  type        = string
  default     = null

  validation {
    condition     = var.subnet_id != null || var.gateway_id != null
    error_message = "resource_aws_route_table_association, subnet_id - Either subnet_id or gateway_id must be provided."
  }

  validation {
    condition     = !(var.subnet_id != null && var.gateway_id != null)
    error_message = "resource_aws_route_table_association, subnet_id - subnet_id conflicts with gateway_id. Only one can be specified."
  }
}

variable "gateway_id" {
  description = "The gateway ID to create an association. Conflicts with subnet_id."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "The ID of the routing table to associate with."
  type        = string

  validation {
    condition     = var.route_table_id != null && var.route_table_id != ""
    error_message = "resource_aws_route_table_association, route_table_id - route_table_id is required and cannot be empty."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the route table association."
  type        = string
  default     = "5m"
}

variable "timeouts_update" {
  description = "Timeout for updating the route table association."
  type        = string
  default     = "2m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the route table association."
  type        = string
  default     = "5m"
}