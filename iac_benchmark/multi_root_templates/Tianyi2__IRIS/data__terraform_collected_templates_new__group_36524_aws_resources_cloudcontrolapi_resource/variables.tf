variable "desired_state" {
  description = "JSON string matching the CloudFormation resource type schema with desired configuration."
  type        = string

  validation {
    condition     = can(jsondecode(var.desired_state))
    error_message = "resource_aws_cloudcontrolapi_resource, desired_state must be a valid JSON string."
  }
}

variable "type_name" {
  description = "CloudFormation resource type name. For example, AWS::EC2::VPC."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]+::[A-Za-z0-9]+::[A-Za-z0-9]+$", var.type_name))
    error_message = "resource_aws_cloudcontrolapi_resource, type_name must be in the format 'Namespace::Service::Resource' (e.g., AWS::EC2::VPC)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_cloudcontrolapi_resource, region must be a valid AWS region identifier."
  }
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role to assume for operations."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.role_arn))
    error_message = "resource_aws_cloudcontrolapi_resource, role_arn must be a valid IAM role ARN."
  }
}

variable "schema" {
  description = "JSON string of the CloudFormation resource type schema which is used for plan time validation where possible."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.schema == null || can(jsondecode(var.schema))
    error_message = "resource_aws_cloudcontrolapi_resource, schema must be a valid JSON string when provided."
  }
}

variable "type_version_id" {
  description = "Identifier of the CloudFormation resource type version."
  type        = string
  default     = null

  validation {
    condition     = var.type_version_id == null || can(regex("^[a-zA-Z0-9-]+$", var.type_version_id))
    error_message = "resource_aws_cloudcontrolapi_resource, type_version_id must be a valid CloudFormation resource type version identifier."
  }
}