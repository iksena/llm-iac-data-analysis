variable "display_name" {
  description = "Name of the Amazon Q application"
  type        = string
}

variable "iam_service_role_arn" {
  description = "ARN of an IAM role with permissions to access your Amazon CloudWatch logs and metrics"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.iam_service_role_arn))
    error_message = "resource_aws_qbusiness_application, iam_service_role_arn must be a valid IAM role ARN."
  }
}

variable "identity_center_instance_arn" {
  description = "ARN of the IAM Identity Center instance you are either creating for — or connecting to — your Amazon Q Business application"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:sso:::instance/", var.identity_center_instance_arn))
    error_message = "resource_aws_qbusiness_application, identity_center_instance_arn must be a valid IAM Identity Center instance ARN."
  }
}

variable "attachments_configuration" {
  description = "Information about whether file upload functionality is activated or deactivated for your end user"
  type = object({
    attachments_control_mode = string
  })

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.attachments_configuration.attachments_control_mode)
    error_message = "resource_aws_qbusiness_application, attachments_control_mode must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Amazon Q application"
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "Information about encryption configuration"
  type = object({
    kms_key_id = string
  })
  default = null

  validation {
    condition     = var.encryption_configuration == null ? true : can(regex("^(arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+|[a-f0-9-]+)$", var.encryption_configuration.kms_key_id))
    error_message = "resource_aws_qbusiness_application, kms_key_id must be a valid KMS key ID or ARN when encryption_configuration is provided."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
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