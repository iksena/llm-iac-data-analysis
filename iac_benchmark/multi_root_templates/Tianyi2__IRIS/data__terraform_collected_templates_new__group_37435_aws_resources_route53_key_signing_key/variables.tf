variable "hosted_zone_id" {
  description = "Identifier of the Route 53 Hosted Zone."
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.hosted_zone_id))
    error_message = "resource_aws_route53_key_signing_key, hosted_zone_id must be a valid Route 53 Hosted Zone identifier starting with 'Z' followed by alphanumeric characters."
  }
}

variable "key_management_service_arn" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key. This must be unique for each key-signing key (KSK) in a single hosted zone. This key must be in the us-east-1 Region and meet certain requirements."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[^:]+:[0-9]{12}:key/[a-f0-9-]+$", var.key_management_service_arn))
    error_message = "resource_aws_route53_key_signing_key, key_management_service_arn must be a valid KMS key ARN."
  }
}

variable "name" {
  description = "Name of the key-signing key (KSK). Must be unique for each key-signing key in the same hosted zone."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_route53_key_signing_key, name must be between 1 and 128 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_route53_key_signing_key, name can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "status" {
  description = "Status of the key-signing key (KSK). Valid values: ACTIVE, INACTIVE."
  type        = string
  default     = "ACTIVE"

  validation {
    condition     = contains(["ACTIVE", "INACTIVE"], var.status)
    error_message = "resource_aws_route53_key_signing_key, status must be either 'ACTIVE' or 'INACTIVE'."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_route53_key_signing_key, timeouts must be specified in the format of number followed by 's' (seconds), 'm' (minutes), or 'h' (hours)."
  }
}