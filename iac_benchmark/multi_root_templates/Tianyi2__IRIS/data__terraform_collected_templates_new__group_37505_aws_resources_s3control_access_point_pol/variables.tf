variable "access_point_arn" {
  description = "The ARN of the access point that you want to associate with the specified policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:[a-zA-Z0-9-]+:[0-9]+:accesspoint/[a-zA-Z0-9.-]+$", var.access_point_arn))
    error_message = "resource_aws_s3control_access_point_policy, access_point_arn must be a valid S3 access point ARN."
  }
}

variable "policy" {
  description = "The policy that you want to apply to the specified access point."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_s3control_access_point_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_s3control_access_point_policy, policy cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_s3control_access_point_policy, region must be a valid AWS region format (e.g., us-east-1, eu-west-1, us-gov-east-1) or null."
  }
}