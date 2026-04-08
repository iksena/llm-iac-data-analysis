variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_appfabric_app_bundle, region must be a valid AWS region format."
  }
}

variable "customer_managed_key_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Key Management Service (AWS KMS) key to use to encrypt the application data. If this is not specified, an AWS owned key is used for encryption."
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}$", var.customer_managed_key_arn))
    error_message = "resource_aws_appfabric_app_bundle, customer_managed_key_arn must be a valid AWS KMS key ARN format."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\s\\S]*$", k)) && can(regex("^[\\s\\S]*$", v))])
    error_message = "resource_aws_appfabric_app_bundle, tags must be a valid map of strings."
  }
}