variable "account_id" {
  description = "Account ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_config_aggregate_authorization, account_id must be a 12-digit AWS account ID."
  }
}

variable "authorized_aws_region" {
  description = "The region authorized to collect aggregated data"
  type        = string
  default     = null

  validation {
    condition     = var.authorized_aws_region == null || can(regex("^[a-z0-9-]+$", var.authorized_aws_region))
    error_message = "resource_aws_config_aggregate_authorization, authorized_aws_region must be a valid AWS region name."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_config_aggregate_authorization, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}