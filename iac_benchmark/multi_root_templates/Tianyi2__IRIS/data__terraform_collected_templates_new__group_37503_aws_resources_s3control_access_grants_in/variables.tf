variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_s3control_access_grants_instance_resource_policy, region must be a valid AWS region format or null."
  }
}

variable "account_id" {
  description = "The AWS account ID for the S3 Access Grants instance. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_access_grants_instance_resource_policy, account_id must be a valid 12-digit AWS account ID or null."
  }
}

variable "policy" {
  description = "The policy document."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_s3control_access_grants_instance_resource_policy, policy must be a valid JSON document or null."
  }
}