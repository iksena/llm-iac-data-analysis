variable "schema_handler_package" {
  description = "URL to the S3 bucket containing the extension project package that contains the necessary files for the extension you want to register. Must begin with s3:// or https://."
  type        = string

  validation {
    condition     = can(regex("^(s3://|https://)", var.schema_handler_package))
    error_message = "resource_aws_cloudformation_type, schema_handler_package must begin with 's3://' or 'https://'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role for CloudFormation to assume when invoking the extension."
  type        = string
  default     = null

  validation {
    condition     = var.execution_role_arn == null || can(regex("^arn:aws:iam::", var.execution_role_arn))
    error_message = "resource_aws_cloudformation_type, execution_role_arn must be a valid IAM role ARN starting with 'arn:aws:iam::'."
  }
}

variable "type" {
  description = "CloudFormation Registry Type. For example, RESOURCE or MODULE."
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["RESOURCE", "MODULE"], var.type)
    error_message = "resource_aws_cloudformation_type, type must be either 'RESOURCE' or 'MODULE'."
  }
}

variable "type_name" {
  description = "CloudFormation Type name. For example, ExampleCompany::ExampleService::ExampleResource."
  type        = string
  default     = null

  validation {
    condition     = var.type_name == null || can(regex("^[A-Za-z0-9]+::[A-Za-z0-9]+::[A-Za-z0-9]+$", var.type_name))
    error_message = "resource_aws_cloudformation_type, type_name must follow the pattern 'CompanyName::ServiceName::ResourceName'."
  }
}

variable "logging_config" {
  description = "Configuration block containing logging configuration."
  type = object({
    log_group_name = string
    log_role_arn   = string
  })
  default = null

  validation {
    condition = var.logging_config == null || (
      can(regex("^[a-zA-Z0-9._/-]+$", var.logging_config.log_group_name)) &&
      can(regex("^arn:aws:iam::", var.logging_config.log_role_arn))
    )
    error_message = "resource_aws_cloudformation_type, logging_config log_group_name must be a valid CloudWatch Log Group name and log_role_arn must be a valid IAM role ARN."
  }
}