variable "name" {
  description = "Unique identifier of the application"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_m2_application, name must not be empty."
  }
}

variable "description" {
  description = "Description of the application"
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_m2_application, description must not be empty."
  }
}

variable "engine_type" {
  description = "Engine type must be microfocus or bluage"
  type        = string

  validation {
    condition     = contains(["microfocus", "bluage"], var.engine_type)
    error_message = "resource_aws_m2_application, engine_type must be either 'microfocus' or 'bluage'."
  }
}

variable "definition" {
  description = "The application definition for this application. You can specify either inline JSON or an S3 bucket location"
  type = object({
    content     = optional(string)
    s3_location = optional(string)
  })
  default = null

  validation {
    condition = var.definition == null || (
      (var.definition.content != null && var.definition.s3_location == null) ||
      (var.definition.content == null && var.definition.s3_location != null)
    )
    error_message = "resource_aws_m2_application, definition must specify either content or s3_location, but not both."
  }
}

variable "kms_key_id" {
  description = "KMS Key to use for the Application"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of role for application to use to access AWS resources"
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_m2_application, role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}