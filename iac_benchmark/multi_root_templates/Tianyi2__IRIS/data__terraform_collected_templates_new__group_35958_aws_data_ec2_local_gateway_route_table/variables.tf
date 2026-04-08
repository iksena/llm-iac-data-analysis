variable "local_gateway_route_table_id" {
  description = "Local Gateway Route Table Id assigned to desired local gateway route table"
  type        = string
  default     = null

  validation {
    condition     = var.local_gateway_route_table_id == null || can(regex("^lgw-rtb-[0-9a-f]{8,17}$", var.local_gateway_route_table_id))
    error_message = "data_aws_ec2_local_gateway_route_table, local_gateway_route_table_id must be a valid Local Gateway Route Table ID (format: lgw-rtb-xxxxxxxxx)."
  }
}

variable "local_gateway_id" {
  description = "ID of the specific local gateway route table to retrieve"
  type        = string
  default     = null

  validation {
    condition     = var.local_gateway_id == null || can(regex("^lgw-[0-9a-f]{8,17}$", var.local_gateway_id))
    error_message = "data_aws_ec2_local_gateway_route_table, local_gateway_id must be a valid Local Gateway ID (format: lgw-xxxxxxxxx)."
  }
}

variable "outpost_arn" {
  description = "ARN of the Outpost the local gateway route table is associated with"
  type        = string
  default     = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws[a-zA-Z-]*:outposts:[a-z0-9-]+:\\d{12}:outpost/op-[0-9a-f]{8,17}$", var.outpost_arn))
    error_message = "data_aws_ec2_local_gateway_route_table, outpost_arn must be a valid Outpost ARN."
  }
}

variable "state" {
  description = "State of the local gateway route table"
  type        = string
  default     = null

  validation {
    condition     = var.state == null || contains(["available", "pending", "deleting", "deleted"], var.state)
    error_message = "data_aws_ec2_local_gateway_route_table, state must be one of: available, pending, deleting, deleted."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired local gateway route table"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "data_aws_ec2_local_gateway_route_table, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "filter" {
  description = "Complex filters for querying local gateway route tables"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : length(f.name) > 0 && length(f.values) > 0])
    error_message = "data_aws_ec2_local_gateway_route_table, filter name and values must not be empty."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeouts_read))
    error_message = "data_aws_ec2_local_gateway_route_table, timeouts_read must be a valid duration (e.g., 20m, 1h, 30s)."
  }
}