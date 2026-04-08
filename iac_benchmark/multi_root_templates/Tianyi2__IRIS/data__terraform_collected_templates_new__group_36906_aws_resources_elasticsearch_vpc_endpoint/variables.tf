variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_elasticsearch_vpc_endpoint, region must be a valid AWS region format or null."
  }
}

variable "domain_arn" {
  description = "Specifies the Amazon Resource Name (ARN) of the domain to create the endpoint for"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:es:[a-z0-9-]+:[0-9]+:domain/[a-zA-Z0-9-]+$", var.domain_arn))
    error_message = "resource_aws_elasticsearch_vpc_endpoint, domain_arn must be a valid Elasticsearch domain ARN."
  }
}

variable "vpc_options" {
  description = "Options to specify the subnets and security groups for the endpoint"
  type = object({
    security_group_ids = optional(list(string), [])
    subnet_ids         = list(string)
  })

  validation {
    condition     = length(var.vpc_options.subnet_ids) >= 1 && length(var.vpc_options.subnet_ids) <= 2
    error_message = "resource_aws_elasticsearch_vpc_endpoint, subnet_ids must contain 1 or 2 subnet IDs."
  }

  validation {
    condition = alltrue([
      for sg_id in var.vpc_options.security_group_ids : can(regex("^sg-[0-9a-fA-F]+$", sg_id))
    ])
    error_message = "resource_aws_elasticsearch_vpc_endpoint, security_group_ids must contain valid security group IDs."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.vpc_options.subnet_ids : can(regex("^subnet-[0-9a-fA-F]+$", subnet_id))
    ])
    error_message = "resource_aws_elasticsearch_vpc_endpoint, subnet_ids must contain valid subnet IDs."
  }
}

variable "timeouts" {
  description = "Configuration options for resource operation timeouts"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "90m")
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "90m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_elasticsearch_vpc_endpoint, timeouts must be in format like '60m', '5s', or '2h'."
  }
}