variable "instance_arn" {
  description = "ARN of the SSO Instance associated with the permission set"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/", var.instance_arn))
    error_message = "data_aws_ssoadmin_permission_sets, instance_arn must be a valid SSO instance ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssoadmin_permission_sets, region must be a valid AWS region name or null."
  }
}