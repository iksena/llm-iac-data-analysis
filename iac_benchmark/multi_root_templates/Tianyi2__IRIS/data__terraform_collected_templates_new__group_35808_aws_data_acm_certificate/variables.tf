variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain" {
  description = "Domain of the certificate to look up. If set and no certificate is found with this name, an error will be returned."
  type        = string
  default     = null
}

variable "key_types" {
  description = "List of key algorithms to filter certificates. By default, ACM does not return all certificate types when searching."
  type        = list(string)
  default     = null
}

variable "statuses" {
  description = "List of statuses on which to filter the returned list. Valid values are PENDING_VALIDATION, ISSUED, INACTIVE, EXPIRED, VALIDATION_TIMED_OUT, REVOKED and FAILED. If no value is specified, only certificates in the ISSUED state are returned."
  type        = list(string)
  default     = null

  validation {
    condition = var.statuses == null ? true : alltrue([
      for status in var.statuses : contains([
        "PENDING_VALIDATION",
        "ISSUED",
        "INACTIVE",
        "EXPIRED",
        "VALIDATION_TIMED_OUT",
        "REVOKED",
        "FAILED"
      ], status)
    ])
    error_message = "data_aws_acm_certificate, statuses must be one of: PENDING_VALIDATION, ISSUED, INACTIVE, EXPIRED, VALIDATION_TIMED_OUT, REVOKED, FAILED."
  }
}

variable "types" {
  description = "List of types on which to filter the returned list. Valid values are AMAZON_ISSUED, PRIVATE, and IMPORTED."
  type        = list(string)
  default     = null

  validation {
    condition = var.types == null ? true : alltrue([
      for type in var.types : contains([
        "AMAZON_ISSUED",
        "PRIVATE",
        "IMPORTED"
      ], type)
    ])
    error_message = "data_aws_acm_certificate, types must be one of: AMAZON_ISSUED, PRIVATE, IMPORTED."
  }
}

variable "most_recent" {
  description = "If set to true, it sorts the certificates matched by previous criteria by the NotBefore field, returning only the most recent one. If set to false, it returns an error if more than one certificate is found. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags, each pair of which must exactly match a pair on the desired certificates."
  type        = map(string)
  default     = null
}