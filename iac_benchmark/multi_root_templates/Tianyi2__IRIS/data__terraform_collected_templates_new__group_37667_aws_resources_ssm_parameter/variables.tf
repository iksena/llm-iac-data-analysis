variable "name" {
  description = "Name of the parameter. If the name contains a path (e.g., any forward slashes (`/`)), it must be fully qualified with a leading forward slash (`/`). For additional requirements and constraints, see the AWS SSM User Guide."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssm_parameter, name cannot be empty."
  }
}

variable "type" {
  description = "Type of the parameter. Valid types are String, StringList and SecureString."
  type        = string

  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.type)
    error_message = "resource_aws_ssm_parameter, type must be one of: String, StringList, SecureString."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "allowed_pattern" {
  description = "Regular expression used to validate the parameter value."
  type        = string
  default     = null
}

variable "data_type" {
  description = "Data type of the parameter. Valid values: text, aws:ssm:integration and aws:ec2:image for AMI format."
  type        = string
  default     = null

  validation {
    condition     = var.data_type == null || contains(["text", "aws:ssm:integration", "aws:ec2:image"], var.data_type)
    error_message = "resource_aws_ssm_parameter, data_type must be one of: text, aws:ssm:integration, aws:ec2:image."
  }
}

variable "description" {
  description = "Description of the parameter."
  type        = string
  default     = null
}

variable "insecure_value" {
  description = "Value of the parameter. Use caution: This value is never marked as sensitive in the Terraform plan output. This argument is not valid with a type of SecureString."
  type        = string
  default     = null

  validation {
    condition     = var.insecure_value == null || var.type != "SecureString"
    error_message = "resource_aws_ssm_parameter, insecure_value cannot be used with type SecureString."
  }
}

variable "key_id" {
  description = "KMS key ID or ARN for encrypting a SecureString."
  type        = string
  default     = null
}

variable "overwrite" {
  description = "Overwrite an existing parameter. If not specified, defaults to false during create operations to avoid overwriting existing resources and then true for all subsequent operations once the resource is managed by Terraform."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "tier" {
  description = "Parameter tier to assign to the parameter. If not specified, will use the default parameter tier for the region. Valid tiers are Standard, Advanced, and Intelligent-Tiering."
  type        = string
  default     = null

  validation {
    condition     = var.tier == null || contains(["Standard", "Advanced", "Intelligent-Tiering"], var.tier)
    error_message = "resource_aws_ssm_parameter, tier must be one of: Standard, Advanced, Intelligent-Tiering."
  }
}

variable "value" {
  description = "Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type."
  type        = string
  default     = null
  sensitive   = true
}

variable "value_wo" {
  description = "Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type. Additionally, write-only values are never stored to state."
  type        = string
  default     = null
  sensitive   = true
}

variable "value_wo_version" {
  description = "Used together with value_wo to trigger an update. Increment this value when an update to the value_wo is required."
  type        = number
  default     = null

  validation {
    condition     = var.value_wo_version == null || (var.value_wo != null && var.value_wo_version != null)
    error_message = "resource_aws_ssm_parameter, value_wo_version is required when value_wo is set."
  }
}