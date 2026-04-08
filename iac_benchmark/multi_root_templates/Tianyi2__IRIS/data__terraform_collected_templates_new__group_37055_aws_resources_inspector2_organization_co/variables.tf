variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "auto_enable_ec2" {
  description = "Whether Amazon EC2 scans are automatically enabled for new members of your Amazon Inspector organization"
  type        = bool

  validation {
    condition     = var.auto_enable_ec2 != null
    error_message = "resource_aws_inspector2_organization_configuration, auto_enable_ec2 is required."
  }
}

variable "auto_enable_ecr" {
  description = "Whether Amazon ECR scans are automatically enabled for new members of your Amazon Inspector organization"
  type        = bool

  validation {
    condition     = var.auto_enable_ecr != null
    error_message = "resource_aws_inspector2_organization_configuration, auto_enable_ecr is required."
  }
}

variable "auto_enable_code_repository" {
  description = "Whether code repository scans are automatically enabled for new members of your Amazon Inspector organization"
  type        = bool
  default     = null
}

variable "auto_enable_lambda" {
  description = "Whether Lambda Function scans are automatically enabled for new members of your Amazon Inspector organization"
  type        = bool
  default     = null
}

variable "auto_enable_lambda_code" {
  description = "Whether AWS Lambda code scans are automatically enabled for new members of your Amazon Inspector organization"
  type        = bool
  default     = null

  validation {
    condition     = var.auto_enable_lambda_code == null || var.auto_enable_lambda_code == false || (var.auto_enable_lambda_code == true && var.auto_enable_lambda == true)
    error_message = "resource_aws_inspector2_organization_configuration, auto_enable_lambda_code requires auto_enable_lambda to be true when auto_enable_lambda_code is true."
  }
}

variable "create_timeout" {
  description = "Timeout for create operations"
  type        = string
  default     = "5m"
}

variable "update_timeout" {
  description = "Timeout for update operations"
  type        = string
  default     = "5m"
}

variable "delete_timeout" {
  description = "Timeout for delete operations"
  type        = string
  default     = "5m"
}