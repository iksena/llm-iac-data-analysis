variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "Amazon Resource Name (ARN) of the ECS resource to tag."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ecs:[^:]*:[^:]*:[^:]*", var.resource_arn))
    error_message = "resource_aws_ecs_tag, resource_arn must be a valid ECS ARN starting with 'arn:aws:ecs:'."
  }
}

variable "key" {
  description = "Tag name."
  type        = string

  validation {
    condition     = length(var.key) > 0 && length(var.key) <= 128
    error_message = "resource_aws_ecs_tag, key must be between 1 and 128 characters."
  }
}

variable "value" {
  description = "Tag value."
  type        = string

  validation {
    condition     = length(var.value) <= 256
    error_message = "resource_aws_ecs_tag, value must be 256 characters or less."
  }
}