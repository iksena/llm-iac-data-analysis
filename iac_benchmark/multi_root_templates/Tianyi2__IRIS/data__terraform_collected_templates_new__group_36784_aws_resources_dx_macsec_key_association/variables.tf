variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cak" {
  description = "The MAC Security (MACsec) CAK to associate with the dedicated connection. The valid values are 64 hexadecimal characters (0-9, A-E). Required if using ckn."
  type        = string
  default     = null

  validation {
    condition     = var.cak == null || can(regex("^[0-9A-Ea-e]{64}$", var.cak))
    error_message = "resource_aws_dx_macsec_key_association, cak must be exactly 64 hexadecimal characters (0-9, A-E)."
  }
}

variable "ckn" {
  description = "The MAC Security (MACsec) CKN to associate with the dedicated connection. The valid values are 64 hexadecimal characters (0-9, A-E). Required if using cak."
  type        = string
  default     = null

  validation {
    condition     = var.ckn == null || can(regex("^[0-9A-Ea-e]{64}$", var.ckn))
    error_message = "resource_aws_dx_macsec_key_association, ckn must be exactly 64 hexadecimal characters (0-9, A-E)."
  }
}

variable "connection_id" {
  description = "The ID of the dedicated Direct Connect connection. The connection must be a dedicated connection in the AVAILABLE state."
  type        = string

  validation {
    condition     = can(regex("^dxcon-[0-9a-f]{8}$", var.connection_id))
    error_message = "resource_aws_dx_macsec_key_association, connection_id must be a valid Direct Connect connection ID (format: dxcon-xxxxxxxx)."
  }
}

variable "secret_arn" {
  description = "The Amazon Resource Name (ARN) of the MAC Security (MACsec) secret key to associate with the dedicated connection."
  type        = string
  default     = null

  validation {
    condition     = var.secret_arn == null || can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:", var.secret_arn))
    error_message = "resource_aws_dx_macsec_key_association, secret_arn must be a valid AWS Secrets Manager ARN."
  }
}

# Validation for mutual exclusivity of ckn/cak with secret_arn
variable "validate_mutual_exclusivity" {
  description = "Internal validation variable to ensure ckn/cak are mutually exclusive with secret_arn"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_mutual_exclusivity == true
    error_message = "resource_aws_dx_macsec_key_association, ckn and cak are mutually exclusive with secret_arn - these arguments cannot be used together."
  }
}

# Validation for ckn and cak dependency
variable "validate_ckn_cak_dependency" {
  description = "Internal validation variable to ensure ckn and cak are both provided together"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_ckn_cak_dependency == true
    error_message = "resource_aws_dx_macsec_key_association, ckn and cak must both be provided together or both be null."
  }
}