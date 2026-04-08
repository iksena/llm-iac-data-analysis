variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled in this cluster."
  type        = bool

  validation {
    condition     = var.deletion_protection_enabled != null
    error_message = "resource_aws_dsql_cluster, deletion_protection_enabled is required and cannot be null."
  }
}

variable "kms_encryption_key" {
  description = "The ARN of the AWS KMS key that encrypts data in the DSQL Cluster, or 'AWS_OWNED_KMS_KEY'."
  type        = string
  default     = null

  validation {
    condition     = var.kms_encryption_key == null || can(regex("^(arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+|AWS_OWNED_KMS_KEY)$", var.kms_encryption_key))
    error_message = "resource_aws_dsql_cluster, kms_encryption_key must be a valid KMS key ARN or 'AWS_OWNED_KMS_KEY'."
  }
}

variable "multi_region_properties" {
  description = "Multi-region properties of the DSQL Cluster."
  type = object({
    witness_region = string
  })
  default = null

  validation {
    condition = var.multi_region_properties == null || (
      var.multi_region_properties.witness_region != null &&
      can(regex("^[a-z0-9-]+$", var.multi_region_properties.witness_region))
    )
    error_message = "resource_aws_dsql_cluster, multi_region_properties witness_region is required when multi_region_properties is specified and must be a valid AWS region."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_dsql_cluster, region must be a valid AWS region format."
  }
}

variable "tags" {
  description = "Set of tags to be associated with the AWS DSQL Cluster resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", k)) && can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", v))
    ])
    error_message = "resource_aws_dsql_cluster, tags keys and values must contain only valid characters."
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
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.create)),
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.update)),
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    ])
    error_message = "resource_aws_dsql_cluster, timeouts must be valid duration strings (e.g., '30m', '1h', '300s')."
  }
}