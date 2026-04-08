variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_aws_applicationinsights_application, resource_group_name must not be empty."
  }

  validation {
    condition     = length(var.resource_group_name) <= 128
    error_message = "resource_aws_applicationinsights_application, resource_group_name must be 128 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.resource_group_name))
    error_message = "resource_aws_applicationinsights_application, resource_group_name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_applicationinsights_application, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "auto_config_enabled" {
  description = "Indicates whether Application Insights automatically configures unmonitored resources in the resource group"
  type        = bool
  default     = null
}

variable "auto_create" {
  description = "Configures all of the resources in the resource group by applying the recommended configurations"
  type        = bool
  default     = null
}

variable "cwe_monitor_enabled" {
  description = "Indicates whether Application Insights can listen to CloudWatch events for the application resources, such as instance terminated, failed deployment, and others"
  type        = bool
  default     = null
}

variable "grouping_type" {
  description = "Application Insights can create applications based on a resource group or on an account. To create an account-based application using all of the resources in the account, set this parameter to ACCOUNT_BASED"
  type        = string
  default     = null

  validation {
    condition     = var.grouping_type == null || contains(["ACCOUNT_BASED"], var.grouping_type)
    error_message = "resource_aws_applicationinsights_application, grouping_type must be ACCOUNT_BASED when specified."
  }
}

variable "ops_center_enabled" {
  description = "When set to true, creates opsItems for any problems detected on an application"
  type        = bool
  default     = null
}

variable "ops_item_sns_topic_arn" {
  description = "SNS topic provided to Application Insights that is associated to the created opsItem. Allows you to receive notifications for updates to the opsItem"
  type        = string
  default     = null

  validation {
    condition     = var.ops_item_sns_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.ops_item_sns_topic_arn))
    error_message = "resource_aws_applicationinsights_application, ops_item_sns_topic_arn must be a valid SNS topic ARN."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_applicationinsights_application, tags cannot exceed 50 tags."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128 && length(key) > 0
    ])
    error_message = "resource_aws_applicationinsights_application, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_applicationinsights_application, tags values must be 256 characters or less."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) : !startswith(key, "aws:")
    ])
    error_message = "resource_aws_applicationinsights_application, tags keys cannot start with 'aws:'."
  }
}