variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the traffic mirror filter rule"
  type        = string
  default     = null
}

variable "traffic_mirror_filter_id" {
  description = "ID of the traffic mirror filter to which this rule should be added"
  type        = string

  validation {
    condition     = can(regex("^tmf-[0-9a-f]{17}$", var.traffic_mirror_filter_id))
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, traffic_mirror_filter_id must be a valid traffic mirror filter ID starting with 'tmf-' followed by 17 hexadecimal characters."
  }
}

variable "destination_cidr_block" {
  description = "Destination CIDR block to assign to the Traffic Mirror rule"
  type        = string

  validation {
    condition     = can(cidrhost(var.destination_cidr_block, 0))
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, destination_cidr_block must be a valid CIDR block."
  }
}

variable "destination_port_range" {
  description = "Destination port range. Supported only when the protocol is set to TCP(6) or UDP(17)"
  type = object({
    from_port = optional(number)
    to_port   = optional(number)
  })
  default = null

  validation {
    condition = var.destination_port_range == null || (
      var.destination_port_range.from_port == null ||
      (var.destination_port_range.from_port >= 0 && var.destination_port_range.from_port <= 65535)
    )
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, destination_port_range from_port must be between 0 and 65535."
  }

  validation {
    condition = var.destination_port_range == null || (
      var.destination_port_range.to_port == null ||
      (var.destination_port_range.to_port >= 0 && var.destination_port_range.to_port <= 65535)
    )
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, destination_port_range to_port must be between 0 and 65535."
  }
}

variable "protocol" {
  description = "Protocol number, for example 17 (UDP), to assign to the Traffic Mirror rule"
  type        = number
  default     = null

  validation {
    condition     = var.protocol == null || (var.protocol >= 0 && var.protocol <= 255)
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, protocol must be between 0 and 255."
  }
}

variable "rule_action" {
  description = "Action to take (accept | reject) on the filtered traffic"
  type        = string

  validation {
    condition     = contains(["accept", "reject"], var.rule_action)
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, rule_action must be either 'accept' or 'reject'."
  }
}

variable "rule_number" {
  description = "Number of the Traffic Mirror rule. This number must be unique for each Traffic Mirror rule in a given direction"
  type        = number

  validation {
    condition     = var.rule_number >= 1 && var.rule_number <= 32766
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, rule_number must be between 1 and 32766."
  }
}

variable "source_cidr_block" {
  description = "Source CIDR block to assign to the Traffic Mirror rule"
  type        = string

  validation {
    condition     = can(cidrhost(var.source_cidr_block, 0))
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, source_cidr_block must be a valid CIDR block."
  }
}

variable "source_port_range" {
  description = "Source port range. Supported only when the protocol is set to TCP(6) or UDP(17)"
  type = object({
    from_port = optional(number)
    to_port   = optional(number)
  })
  default = null

  validation {
    condition = var.source_port_range == null || (
      var.source_port_range.from_port == null ||
      (var.source_port_range.from_port >= 0 && var.source_port_range.from_port <= 65535)
    )
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, source_port_range from_port must be between 0 and 65535."
  }

  validation {
    condition = var.source_port_range == null || (
      var.source_port_range.to_port == null ||
      (var.source_port_range.to_port >= 0 && var.source_port_range.to_port <= 65535)
    )
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, source_port_range to_port must be between 0 and 65535."
  }
}

variable "traffic_direction" {
  description = "Direction of traffic to be captured"
  type        = string

  validation {
    condition     = contains(["ingress", "egress"], var.traffic_direction)
    error_message = "resource_aws_ec2_traffic_mirror_filter_rule, traffic_direction must be either 'ingress' or 'egress'."
  }
}