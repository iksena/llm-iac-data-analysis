variable "domain_name" {
  description = "The name of the domain that will have its parent DNS zone updated with the Delegation Signer record."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "resource_aws_route53domains_delegation_signer_record, domain_name must be a valid domain name format."
  }
}

variable "signing_attributes_algorithm" {
  description = "Algorithm which was used to generate the digest from the public key."
  type        = number

  validation {
    condition     = contains([3, 5, 6, 7, 8, 10, 12, 13, 14, 15, 16], var.signing_attributes_algorithm)
    error_message = "resource_aws_route53domains_delegation_signer_record, signing_attributes_algorithm must be a valid DNSSEC algorithm number."
  }
}

variable "signing_attributes_flags" {
  description = "Defines the type of key. It can be either a KSK (key-signing-key, value 257) or ZSK (zone-signing-key, value 256)."
  type        = number

  validation {
    condition     = contains([256, 257], var.signing_attributes_flags)
    error_message = "resource_aws_route53domains_delegation_signer_record, signing_attributes_flags must be either 256 (ZSK) or 257 (KSK)."
  }
}

variable "signing_attributes_public_key" {
  description = "The base64-encoded public key part of the key pair that is passed to the registry."
  type        = string

  validation {
    condition     = can(base64decode(var.signing_attributes_public_key))
    error_message = "resource_aws_route53domains_delegation_signer_record, signing_attributes_public_key must be a valid base64-encoded string."
  }
}

variable "timeouts_create" {
  description = "How long to wait for the delegation signer record to be created."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_route53domains_delegation_signer_record, timeouts_create must be a valid duration format (e.g., '5m', '1h', '30s')."
  }
}

variable "timeouts_delete" {
  description = "How long to wait for the delegation signer record to be deleted."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_route53domains_delegation_signer_record, timeouts_delete must be a valid duration format (e.g., '5m', '1h', '30s')."
  }
}