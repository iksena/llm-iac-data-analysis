variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, filter name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, filter values must contain at least one value."
  }
}

variable "id" {
  description = "Identifier of the EC2 Transit Gateway Peering Attachment."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.id))
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, id must be a valid Transit Gateway attachment ID format (tgw-attach-xxxxxxxx) or null."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the specific EC2 Transit Gateway Peering Attachment to retrieve."
  type        = map(string)
  default     = null

  validation {
    condition = var.tags == null || alltrue([
      for k, v in var.tags : k != null && k != "" && v != null
    ])
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, tags keys and values must be non-empty strings."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.read == null || can(regex("^[0-9]+[smh]$", var.timeouts.read))
    )
    error_message = "data_aws_ec2_transit_gateway_peering_attachment, timeouts read must be a valid duration format (e.g., 20m, 1h) or null."
  }
}