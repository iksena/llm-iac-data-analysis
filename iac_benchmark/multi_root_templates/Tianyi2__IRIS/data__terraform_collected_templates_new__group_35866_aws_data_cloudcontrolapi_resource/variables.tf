variable "identifier" {
  description = "Identifier of the CloudFormation resource type. For example, vpc-12345678"
  type        = string

  validation {
    condition     = length(var.identifier) > 0
    error_message = "data_aws_cloudcontrolapi_resource, identifier must not be empty."
  }
}

variable "type_name" {
  description = "CloudFormation resource type name. For example, AWS::EC2::VPC"
  type        = string

  validation {
    condition     = length(var.type_name) > 0
    error_message = "data_aws_cloudcontrolapi_resource, type_name must not be empty."
  }

  validation {
    condition     = can(regex("^AWS::[A-Za-z0-9]+::[A-Za-z0-9]+$", var.type_name))
    error_message = "data_aws_cloudcontrolapi_resource, type_name must be a valid CloudFormation resource type name format (AWS::Service::ResourceType)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM Role to assume for operations"
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/", var.role_arn))
    error_message = "data_aws_cloudcontrolapi_resource, role_arn must be a valid IAM role ARN format."
  }
}

variable "type_version_id" {
  description = "Identifier of the CloudFormation resource type version"
  type        = string
  default     = null
}