variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name for identifying the grant."
  type        = string
  default     = null
}

variable "key_id" {
  description = "The unique identifier for the customer master key (CMK) that the grant applies to. Specify the key ID or the Amazon Resource Name (ARN) of the CMK. To specify a CMK in a different AWS account, you must use the key ARN."
  type        = string
}

variable "grantee_principal" {
  description = "The principal that is given permission to perform the operations that the grant permits in ARN format. Note that due to eventual consistency issues around IAM principals, terraform's state may not always be refreshed to reflect what is true in AWS."
  type        = string
}

variable "operations" {
  description = "A list of operations that the grant permits. The permitted values are: Decrypt, Encrypt, GenerateDataKey, GenerateDataKeyWithoutPlaintext, ReEncryptFrom, ReEncryptTo, Sign, Verify, GetPublicKey, CreateGrant, RetireGrant, DescribeKey, GenerateDataKeyPair, or GenerateDataKeyPairWithoutPlaintext."
  type        = list(string)

  validation {
    condition = alltrue([
      for operation in var.operations : contains([
        "Decrypt", "Encrypt", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext",
        "ReEncryptFrom", "ReEncryptTo", "Sign", "Verify", "GetPublicKey",
        "CreateGrant", "RetireGrant", "DescribeKey", "GenerateDataKeyPair",
        "GenerateDataKeyPairWithoutPlaintext"
      ], operation)
    ])
    error_message = "resource_aws_kms_grant, operations must be one of: Decrypt, Encrypt, GenerateDataKey, GenerateDataKeyWithoutPlaintext, ReEncryptFrom, ReEncryptTo, Sign, Verify, GetPublicKey, CreateGrant, RetireGrant, DescribeKey, GenerateDataKeyPair, or GenerateDataKeyPairWithoutPlaintext."
  }
}

variable "retiring_principal" {
  description = "The principal that is given permission to retire the grant by using RetireGrant operation in ARN format. Note that due to eventual consistency issues around IAM principals, terraform's state may not always be refreshed to reflect what is true in AWS."
  type        = string
  default     = null
}

variable "constraints" {
  description = "A structure that you can use to allow certain operations in the grant only when the desired encryption context is present."
  type = object({
    encryption_context_equals = optional(map(string))
    encryption_context_subset = optional(map(string))
  })
  default = null

  validation {
    condition = var.constraints == null || (
      var.constraints.encryption_context_equals == null ||
      var.constraints.encryption_context_subset == null
    )
    error_message = "resource_aws_kms_grant, constraints encryption_context_equals conflicts with encryption_context_subset."
  }
}

variable "grant_creation_tokens" {
  description = "A list of grant tokens to be used when creating the grant."
  type        = list(string)
  default     = null
}

variable "retire_on_delete" {
  description = "If set to false (the default) the grants will be revoked upon deletion, and if set to true the grants will try to be retired upon deletion."
  type        = bool
  default     = false
}