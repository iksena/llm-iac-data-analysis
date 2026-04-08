variable "bypass_policy_lockout_safety_check" {
  description = "Specifies whether to disable the policy lockout check performed when creating or updating the key's policy. Setting this value to true increases the risk that the key becomes unmanageable."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource. Must be between 7 and 30 days."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "resource_aws_kms_external_key, deletion_window_in_days must be between 7 and 30 days."
  }
}

variable "description" {
  description = "Description of the key."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Specifies whether the key is enabled. Keys pending import can only be false. Imported keys default to true unless expired."
  type        = bool
  default     = null
}

variable "key_material_base64" {
  description = "Base64 encoded 256-bit symmetric encryption key material to import. The CMK is permanently associated with this key material. The same key material can be reimported, but you cannot import different key material."
  type        = string
  default     = null
  sensitive   = true
}

variable "key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports."
  type        = string
  default     = "SYMMETRIC_DEFAULT"

  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT", "RSA_2048", "RSA_3072", "RSA_4096", "HMAC_224",
      "HMAC_256", "HMAC_384", "HMAC_512", "ECC_NIST_P256", "ECC_NIST_P384",
      "ECC_NIST_P521", "ECC_SECG_P256K1", "ML_DSA_44", "ML_DSA_65",
      "ML_DSA_87", "SM2"
    ], var.key_spec)
    error_message = "resource_aws_kms_external_key, key_spec must be one of: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_224, HMAC_256, HMAC_384, HMAC_512, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, ECC_SECG_P256K1, ML_DSA_44, ML_DSA_65, ML_DSA_87, SM2."
  }
}

variable "key_usage" {
  description = "Specifies the intended use of the key."
  type        = string
  default     = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "resource_aws_kms_external_key, key_usage must be one of: ENCRYPT_DECRYPT, SIGN_VERIFY, GENERATE_VERIFY_MAC."
  }
}

variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key."
  type        = bool
  default     = false
}

variable "policy" {
  description = "A key policy JSON document. If you do not provide a key policy, AWS KMS attaches a default key policy to the CMK."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A key-value map of tags to assign to the key."
  type        = map(string)
  default     = {}
}

variable "valid_to" {
  description = "Time at which the imported key material expires. When the key material expires, AWS KMS deletes the key material and the CMK becomes unusable. If not specified, key material does not expire. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
  type        = string
  default     = null

  validation {
    condition     = var.valid_to == null || can(formatdate("2006-01-02T15:04:05Z", var.valid_to))
    error_message = "resource_aws_kms_external_key, valid_to must be a valid RFC3339 time string in format YYYY-MM-DDTHH:MM:SSZ."
  }
}