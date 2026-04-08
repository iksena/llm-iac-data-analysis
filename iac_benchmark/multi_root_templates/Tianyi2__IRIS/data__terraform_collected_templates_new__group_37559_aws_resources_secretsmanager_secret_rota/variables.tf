variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "secret_id" {
  description = "Specifies the secret to which you want to add a new version. You can specify either the Amazon Resource Name (ARN) or the friendly name of the secret. The secret must already exist."
  type        = string

  validation {
    condition     = length(var.secret_id) > 0
    error_message = "resource_aws_secretsmanager_secret_rotation, secret_id must not be empty."
  }
}

variable "rotate_immediately" {
  description = "Specifies whether to rotate the secret immediately or wait until the next scheduled rotation window. The rotation schedule is defined in rotation_rules. Defaults to true."
  type        = bool
  default     = true
}

variable "rotation_lambda_arn" {
  description = "Specifies the ARN of the Lambda function that can rotate the secret. Must be supplied if the secret is not managed by AWS."
  type        = string
  default     = null

  validation {
    condition     = var.rotation_lambda_arn == null || can(regex("^arn:aws:lambda:", var.rotation_lambda_arn))
    error_message = "resource_aws_secretsmanager_secret_rotation, rotation_lambda_arn must be a valid Lambda function ARN starting with 'arn:aws:lambda:' when provided."
  }
}

variable "rotation_rules_automatically_after_days" {
  description = "Specifies the number of days between automatic scheduled rotations of the secret. Either automatically_after_days or schedule_expression must be specified."
  type        = number
  default     = null

  validation {
    condition     = var.rotation_rules_automatically_after_days == null || (var.rotation_rules_automatically_after_days >= 1 && var.rotation_rules_automatically_after_days <= 365)
    error_message = "resource_aws_secretsmanager_secret_rotation, rotation_rules_automatically_after_days must be between 1 and 365 days when specified."
  }
}

variable "rotation_rules_duration" {
  description = "The length of the rotation window in hours. For example, 3h for a three hour window."
  type        = string
  default     = null

  validation {
    condition     = var.rotation_rules_duration == null || can(regex("^[0-9]+h$", var.rotation_rules_duration))
    error_message = "resource_aws_secretsmanager_secret_rotation, rotation_rules_duration must be in the format of number followed by 'h' (e.g., '3h') when specified."
  }
}

variable "rotation_rules_schedule_expression" {
  description = "A cron() or rate() expression that defines the schedule for rotating your secret. Either automatically_after_days or schedule_expression must be specified."
  type        = string
  default     = null

  validation {
    condition     = var.rotation_rules_schedule_expression == null || can(regex("^(cron|rate)\\(", var.rotation_rules_schedule_expression))
    error_message = "resource_aws_secretsmanager_secret_rotation, rotation_rules_schedule_expression must be a valid cron() or rate() expression when specified."
  }
}

locals {
  rotation_schedule_specified = var.rotation_rules_automatically_after_days != null || var.rotation_rules_schedule_expression != null
}

