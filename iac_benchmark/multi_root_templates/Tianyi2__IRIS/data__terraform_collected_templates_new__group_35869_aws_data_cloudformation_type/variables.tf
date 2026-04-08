variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_cloudformation_type, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "arn" {
  description = "ARN of the CloudFormation Type. For example, arn:aws:cloudformation:us-west-2::type/resource/AWS-EC2-VPC."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:cloudformation:[a-z0-9-]+::\\w+\\/\\w+\\/[A-Za-z0-9:-]+$", var.arn))
    error_message = "data_aws_cloudformation_type, arn must be a valid CloudFormation Type ARN format or null."
  }
}

variable "type" {
  description = "CloudFormation Registry Type. For example, RESOURCE."
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["RESOURCE", "MODULE", "HOOK"], var.type)
    error_message = "data_aws_cloudformation_type, type must be one of: RESOURCE, MODULE, HOOK, or null."
  }
}

variable "type_name" {
  description = "CloudFormation Type name. For example, AWS::EC2::VPC."
  type        = string
  default     = null

  validation {
    condition     = var.type_name == null || can(regex("^[A-Za-z0-9]+::[A-Za-z0-9]+::[A-Za-z0-9]+$", var.type_name))
    error_message = "data_aws_cloudformation_type, type_name must be in the format Namespace::Service::Type or null."
  }
}

variable "version_id" {
  description = "Identifier of the CloudFormation Type version."
  type        = string
  default     = null

  validation {
    condition     = var.version_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.version_id))
    error_message = "data_aws_cloudformation_type, version_id must be a valid UUID format or null."
  }
}