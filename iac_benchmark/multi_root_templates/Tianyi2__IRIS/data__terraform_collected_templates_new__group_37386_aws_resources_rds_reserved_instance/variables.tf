variable "offering_id" {
  description = "ID of the Reserved DB instance offering to purchase. To determine an offering_id, see the aws_rds_reserved_instance_offering data source."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.offering_id))
    error_message = "resource_aws_rds_reserved_instance, offering_id must be a valid offering ID containing only alphanumeric characters and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_count" {
  description = "Number of instances to reserve."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "resource_aws_rds_reserved_instance, instance_count must be greater than 0."
  }
}

variable "reservation_id" {
  description = "Customer-specified identifier to track this reservation."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the DB reservation."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the reserved instance"
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "Timeout for updating the reserved instance"
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the reserved instance"
  type        = string
  default     = "1m"
}