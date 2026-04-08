variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "directory_id" {
  description = "ID of directory."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.directory_id))
    error_message = "resource_aws_directory_service_log_subscription, directory_id must be a valid directory ID format (d- followed by 10 alphanumeric characters)."
  }
}

variable "log_group_name" {
  description = "Name of the cloudwatch log group to which the logs should be published. The log group should be already created and the directory service principal should be provided with required permission to create stream and publish logs. Changing this value would delete the current subscription and create a new one. A directory can only have one log subscription at a time."
  type        = string

  validation {
    condition     = length(var.log_group_name) > 0 && length(var.log_group_name) <= 512
    error_message = "resource_aws_directory_service_log_subscription, log_group_name must be between 1 and 512 characters long."
  }

  validation {
    condition     = can(regex("^[\\w.-_/]+$", var.log_group_name))
    error_message = "resource_aws_directory_service_log_subscription, log_group_name can only contain alphanumeric characters, hyphens, underscores, periods, and forward slashes."
  }
}