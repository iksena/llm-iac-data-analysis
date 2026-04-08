variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you need to reference a CMK in a different account, you can use only the key ARN. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "name" {
  description = "Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: /_+=.@- Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9/_+=.@-]+$", var.name))
    error_message = "resource_aws_secretsmanager_secret, name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: /_+=.@-"
  }
}

variable "policy" {
  description = "Valid JSON document representing a resource policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Removing policy from your configuration or setting policy to null or an empty string (i.e., policy = \"\") will not delete the policy since it could have been set by aws_secretsmanager_secret_policy. To delete the policy, set it to \"{}\" (an empty JSON document)."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_secretsmanager_secret, policy must be a valid JSON document."
  }
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "resource_aws_secretsmanager_secret, recovery_window_in_days must be 0 to force deletion without recovery or range from 7 to 30 days."
  }
}

variable "replica" {
  description = "Configuration block to support secret replication."
  type = list(object({
    kms_key_id = optional(string)
    region     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.replica : r.region != null && r.region != ""
    ])
    error_message = "resource_aws_secretsmanager_secret, replica region is required and cannot be empty."
  }
}

variable "force_overwrite_replica_secret" {
  description = "Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Key-value map of user-defined tags that are attached to the secret. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}