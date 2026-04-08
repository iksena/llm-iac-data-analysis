variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the log group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9._/-]+$", var.name))
    error_message = "resource_aws_cloudwatch_log_group, name must be a valid CloudWatch log group name containing only alphanumeric characters, periods, underscores, hyphens, and forward slashes."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9._/-]+$", var.name_prefix))
    error_message = "resource_aws_cloudwatch_log_group, name_prefix must be a valid CloudWatch log group name prefix containing only alphanumeric characters, periods, underscores, hyphens, and forward slashes."
  }
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state."
  type        = bool
  default     = false
}

variable "log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD, INFREQUENT_ACCESS, or DELIVERY."
  type        = string
  default     = null

  validation {
    condition     = var.log_group_class == null || contains(["STANDARD", "INFREQUENT_ACCESS", "DELIVERY"], var.log_group_class)
    error_message = "resource_aws_cloudwatch_log_group, log_group_class must be one of: STANDARD, INFREQUENT_ACCESS, or DELIVERY."
  }
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = null

  validation {
    condition     = var.retention_in_days == null || contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.retention_in_days)
    error_message = "resource_aws_cloudwatch_log_group, retention_in_days must be one of: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653."
  }
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_id))
    error_message = "resource_aws_cloudwatch_log_group, kms_key_id must be a valid KMS key ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}