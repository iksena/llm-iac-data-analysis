variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_cloudwatch_log_groups, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "log_group_name_prefix" {
  description = "Group prefix of the Cloudwatch log groups to list"
  type        = string
  default     = null

  validation {
    condition     = var.log_group_name_prefix == null || length(var.log_group_name_prefix) > 0
    error_message = "data_aws_cloudwatch_log_groups, log_group_name_prefix must not be empty when provided."
  }
}