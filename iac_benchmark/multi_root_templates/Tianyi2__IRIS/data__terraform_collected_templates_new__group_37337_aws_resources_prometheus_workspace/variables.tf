variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "alias" {
  description = "The alias of the prometheus workspace."
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If this argument is not provided, then the AWS owned encryption key will be used to encrypt the data in the workspace."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.kms_key_arn))
    error_message = "resource_aws_prometheus_workspace, kms_key_arn must be a valid KMS key ARN."
  }
}

variable "logging_configuration" {
  description = "Logging configuration for the workspace."
  type = object({
    log_group_arn = string
  })
  default = null

  validation {
    condition     = var.logging_configuration == null || can(regex("^arn:aws[a-zA-Z-]*:logs:[a-z0-9-]+:[0-9]{12}:log-group:.+", var.logging_configuration.log_group_arn))
    error_message = "resource_aws_prometheus_workspace, logging_configuration.log_group_arn must be a valid CloudWatch log group ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}