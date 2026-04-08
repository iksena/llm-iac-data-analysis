variable "source_resource" {
  description = "ID or ARN of the resource which is the source of the path. Can be an Instance, Internet Gateway, Network Interface, Transit Gateway, VPC Endpoint, VPC Peering Connection or VPN Gateway. If the resource is in another account, you must specify an ARN."
  type        = string

  validation {
    condition     = length(var.source_resource) > 0
    error_message = "resource_aws_ec2_network_insights_path, source must not be empty."
  }
}

variable "protocol" {
  description = "Protocol to use for analysis. Valid options are tcp or udp."
  type        = string

  validation {
    condition     = contains(["tcp", "udp"], var.protocol)
    error_message = "resource_aws_ec2_network_insights_path, protocol must be either 'tcp' or 'udp'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_ip" {
  description = "IP address of the source resource."
  type        = string
  default     = null
}

variable "destination" {
  description = "ID or ARN of the resource which is the destination of the path. Can be an Instance, Internet Gateway, Network Interface, Transit Gateway, VPC Endpoint, VPC Peering Connection or VPN Gateway. If the resource is in another account, you must specify an ARN."
  type        = string
  default     = null
}

variable "destination_ip" {
  description = "IP address of the destination resource."
  type        = string
  default     = null
}

variable "destination_port" {
  description = "Destination port to analyze access to."
  type        = number
  default     = null

  validation {
    condition     = var.destination_port == null || (var.destination_port >= 1 && var.destination_port <= 65535)
    error_message = "resource_aws_ec2_network_insights_path, destination_port must be between 1 and 65535."
  }
}

variable "filter_at_destination" {
  description = "Scopes the analysis to network paths that match specific filters at the destination."
  type = object({
    destination_address = optional(string)
    destination_port_range = optional(object({
      from_port = optional(number)
      to_port   = optional(number)
    }))
    source_address = optional(string)
    source_port_range = optional(object({
      from_port = optional(number)
      to_port   = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.filter_at_destination == null || (
      var.filter_at_destination.destination_port_range == null ||
      (
        var.filter_at_destination.destination_port_range.from_port == null ||
        var.filter_at_destination.destination_port_range.to_port == null ||
        (
          var.filter_at_destination.destination_port_range.from_port >= 1 &&
          var.filter_at_destination.destination_port_range.from_port <= 65535 &&
          var.filter_at_destination.destination_port_range.to_port >= 1 &&
          var.filter_at_destination.destination_port_range.to_port <= 65535 &&
          var.filter_at_destination.destination_port_range.from_port <= var.filter_at_destination.destination_port_range.to_port
        )
      )
    )
    error_message = "resource_aws_ec2_network_insights_path, filter_at_destination destination_port_range ports must be between 1 and 65535, and from_port must be less than or equal to to_port."
  }

  validation {
    condition = var.filter_at_destination == null || (
      var.filter_at_destination.source_port_range == null ||
      (
        var.filter_at_destination.source_port_range.from_port == null ||
        var.filter_at_destination.source_port_range.to_port == null ||
        (
          var.filter_at_destination.source_port_range.from_port >= 1 &&
          var.filter_at_destination.source_port_range.from_port <= 65535 &&
          var.filter_at_destination.source_port_range.to_port >= 1 &&
          var.filter_at_destination.source_port_range.to_port <= 65535 &&
          var.filter_at_destination.source_port_range.from_port <= var.filter_at_destination.source_port_range.to_port
        )
      )
    )
    error_message = "resource_aws_ec2_network_insights_path, filter_at_destination source_port_range ports must be between 1 and 65535, and from_port must be less than or equal to to_port."
  }
}

variable "filter_at_source" {
  description = "Scopes the analysis to network paths that match specific filters at the source."
  type = object({
    destination_address = optional(string)
    destination_port_range = optional(object({
      from_port = optional(number)
      to_port   = optional(number)
    }))
    source_address = optional(string)
    source_port_range = optional(object({
      from_port = optional(number)
      to_port   = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.filter_at_source == null || (
      var.filter_at_source.destination_port_range == null ||
      (
        var.filter_at_source.destination_port_range.from_port == null ||
        var.filter_at_source.destination_port_range.to_port == null ||
        (
          var.filter_at_source.destination_port_range.from_port >= 1 &&
          var.filter_at_source.destination_port_range.from_port <= 65535 &&
          var.filter_at_source.destination_port_range.to_port >= 1 &&
          var.filter_at_source.destination_port_range.to_port <= 65535 &&
          var.filter_at_source.destination_port_range.from_port <= var.filter_at_source.destination_port_range.to_port
        )
      )
    )
    error_message = "resource_aws_ec2_network_insights_path, filter_at_source destination_port_range ports must be between 1 and 65535, and from_port must be less than or equal to to_port."
  }

  validation {
    condition = var.filter_at_source == null || (
      var.filter_at_source.source_port_range == null ||
      (
        var.filter_at_source.source_port_range.from_port == null ||
        var.filter_at_source.source_port_range.to_port == null ||
        (
          var.filter_at_source.source_port_range.from_port >= 1 &&
          var.filter_at_source.source_port_range.from_port <= 65535 &&
          var.filter_at_source.source_port_range.to_port >= 1 &&
          var.filter_at_source.source_port_range.to_port <= 65535 &&
          var.filter_at_source.source_port_range.from_port <= var.filter_at_source.source_port_range.to_port
        )
      )
    )
    error_message = "resource_aws_ec2_network_insights_path, filter_at_source source_port_range ports must be between 1 and 65535, and from_port must be less than or equal to to_port."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}