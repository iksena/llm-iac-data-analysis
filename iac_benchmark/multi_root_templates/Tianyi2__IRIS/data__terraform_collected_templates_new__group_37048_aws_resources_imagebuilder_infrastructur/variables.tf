variable "instance_profile_name" {
  description = "Name of IAM Instance Profile"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.instance_profile_name))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, instance_profile_name must contain only alphanumeric characters, hyphens, underscores, periods, plus signs, equal signs, commas, and at signs."
  }
}

variable "name" {
  description = "Name for the configuration"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 126
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, name must be between 1 and 126 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "description" {
  description = "Description for the configuration"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, description must be 1024 characters or less."
  }
}

variable "instance_metadata_options" {
  description = "Configuration block with instance metadata options for the HTTP requests that pipeline builds use to launch EC2 build and test instances"
  type = object({
    http_put_response_hop_limit = optional(number)
    http_tokens                 = optional(string)
  })
  default = null

  validation {
    condition = var.instance_metadata_options == null || (
      var.instance_metadata_options.http_put_response_hop_limit == null ||
      (var.instance_metadata_options.http_put_response_hop_limit >= 1 && var.instance_metadata_options.http_put_response_hop_limit <= 64)
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, http_put_response_hop_limit must be between 1 and 64."
  }

  validation {
    condition = var.instance_metadata_options == null || (
      var.instance_metadata_options.http_tokens == null ||
      contains(["required", "optional"], var.instance_metadata_options.http_tokens)
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, http_tokens must be either 'required' or 'optional'."
  }
}

variable "instance_types" {
  description = "Set of EC2 Instance Types"
  type        = set(string)
  default     = null

  validation {
    condition = var.instance_types == null || alltrue([
      for instance_type in var.instance_types : can(regex("^[a-z0-9]+\\.[a-z0-9]+$", instance_type))
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, instance_types must be valid EC2 instance types (e.g., t2.micro, m5.large)."
  }
}

variable "key_pair" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = null

  validation {
    condition     = var.key_pair == null || length(var.key_pair) <= 255
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, key_pair name must be 255 characters or less."
  }
}

variable "logging" {
  description = "Configuration block with logging settings"
  type = object({
    s3_logs = object({
      s3_bucket_name = string
      s3_key_prefix  = optional(string)
    })
  })
  default = null

  validation {
    condition = var.logging == null || (
      length(var.logging.s3_logs.s3_bucket_name) >= 3 &&
      length(var.logging.s3_logs.s3_bucket_name) <= 63
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, s3_bucket_name must be between 3 and 63 characters."
  }

  validation {
    condition     = var.logging == null || can(regex("^[a-z0-9.-]+$", var.logging.s3_logs.s3_bucket_name))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, s3_bucket_name must contain only lowercase letters, numbers, periods, and hyphens."
  }
}

variable "placement" {
  description = "Configuration block with placement settings that define where the instances that are launched from your image will run"
  type = object({
    availability_zone       = optional(string)
    host_id                 = optional(string)
    host_resource_group_arn = optional(string)
    tenancy                 = optional(string)
  })
  default = null

  validation {
    condition = var.placement == null || (
      var.placement.availability_zone == null ||
      can(regex("^[a-z]{2}-[a-z]+-[0-9]+[a-z]$", var.placement.availability_zone))
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, availability_zone must be a valid AWS availability zone format (e.g., us-east-1a)."
  }

  validation {
    condition = var.placement == null || (
      var.placement.host_id == null ||
      can(regex("^h-[0-9a-z]+$", var.placement.host_id))
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, host_id must be a valid dedicated host ID format (e.g., h-0123456789abcdef0)."
  }

  validation {
    condition = var.placement == null || (
      var.placement.host_resource_group_arn == null ||
      can(regex("^arn:aws:resource-groups:[a-z0-9-]+:[0-9]{12}:group/.+$", var.placement.host_resource_group_arn))
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, host_resource_group_arn must be a valid ARN format."
  }

  validation {
    condition = var.placement == null || (
      var.placement.tenancy == null ||
      contains(["default", "dedicated", "host"], var.placement.tenancy)
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, tenancy must be one of 'default', 'dedicated', or 'host'."
  }

  validation {
    condition = var.placement == null || !(
      var.placement.host_id != null && var.placement.host_resource_group_arn != null
    )
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, host_id and host_resource_group_arn are mutually exclusive."
  }
}

variable "resource_tags" {
  description = "Key-value map of resource tags to assign to infrastructure created by the configuration"
  type        = map(string)
  default     = null

  validation {
    condition = var.resource_tags == null || alltrue([
      for key in keys(var.resource_tags) : length(key) >= 1 && length(key) <= 128
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, resource_tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = var.resource_tags == null || alltrue([
      for value in values(var.resource_tags) : length(value) <= 256
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, resource_tags values must be 256 characters or less."
  }
}

variable "security_group_ids" {
  description = "Set of EC2 Security Group identifiers"
  type        = set(string)
  default     = null

  validation {
    condition = var.security_group_ids == null || alltrue([
      for sg_id in var.security_group_ids : can(regex("^sg-[0-9a-f]+$", sg_id))
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, security_group_ids must be valid security group IDs (e.g., sg-12345678)."
  }
}

variable "sns_topic_arn" {
  description = "Amazon Resource Name (ARN) of SNS Topic"
  type        = string
  default     = null

  validation {
    condition     = var.sns_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:.+$", var.sns_topic_arn))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, sns_topic_arn must be a valid SNS topic ARN."
  }
}

variable "subnet_id" {
  description = "EC2 Subnet identifier. Also requires security_group_ids argument"
  type        = string
  default     = null

  validation {
    condition     = var.subnet_id == null || can(regex("^subnet-[0-9a-f]+$", var.subnet_id))
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, subnet_id must be a valid subnet ID (e.g., subnet-12345678)."
  }
}

variable "tags" {
  description = "Key-value map of resource tags to assign to the configuration"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) >= 1 && length(key) <= 128
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_imagebuilder_infrastructure_configuration, tags values must be 256 characters or less."
  }
}

variable "terminate_instance_on_failure" {
  description = "Enable if the instance should be terminated when the pipeline fails"
  type        = bool
  default     = false
}