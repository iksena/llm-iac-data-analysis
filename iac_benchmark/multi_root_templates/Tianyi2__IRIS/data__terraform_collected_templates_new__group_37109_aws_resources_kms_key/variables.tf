variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = null
}

variable "key_usage" {
  description = "Specifies the intended use of the key."
  type        = string
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "resource_aws_kms_key, key_usage must be one of: ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC."
  }
}

variable "custom_key_store_id" {
  description = "ID of the KMS Custom Key Store where the key will be stored instead of KMS (eg CloudHSM)."
  type        = string
  default     = null
}

variable "customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT", "RSA_2048", "RSA_3072", "RSA_4096",
      "HMAC_224", "HMAC_256", "HMAC_384", "HMAC_512",
      "ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521", "ECC_SECG_P256K1",
      "ML_DSA_44", "ML_DSA_65", "ML_DSA_87", "SM2"
    ], var.customer_master_key_spec)
    error_message = "resource_aws_kms_key, customer_master_key_spec must be one of: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_224, HMAC_256, HMAC_384, HMAC_512, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, ECC_SECG_P256K1, ML_DSA_44, ML_DSA_65, ML_DSA_87, or SM2."
  }
}

variable "policy" {
  description = "A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "resource_aws_kms_key, deletion_window_in_days must be between 7 and 30 inclusive."
  }
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled."
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = false
}

variable "rotation_period_in_days" {
  description = "Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive)."
  type        = number
  default     = null
  validation {
    condition     = var.rotation_period_in_days == null || (var.rotation_period_in_days >= 90 && var.rotation_period_in_days <= 2560)
    error_message = "resource_aws_kms_key, rotation_period_in_days must be between 90 and 2560 inclusive."
  }
}

variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the object."
  type        = map(string)
  default     = {}
}

variable "xks_key_id" {
  description = "Identifies the external key that serves as key material for the KMS key in an external key store."
  type        = string
  default     = null
}

variable "create_timeout" {
  description = "Timeout for creating the KMS key."
  type        = string
  default     = "2m"
}