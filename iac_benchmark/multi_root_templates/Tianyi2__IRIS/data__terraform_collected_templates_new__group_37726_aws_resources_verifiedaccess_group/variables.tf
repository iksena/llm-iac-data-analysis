variable "verifiedaccess_instance_id" {
  description = "The id of the verified access instance this group is associated with"
  type        = string

  validation {
    condition     = can(regex("^vai-[0-9a-f]{8,17}$", var.verifiedaccess_instance_id))
    error_message = "resource_aws_verifiedaccess_group, verifiedaccess_instance_id must be a valid Verified Access Instance ID starting with 'vai-'"
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the verified access group"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 255
    error_message = "resource_aws_verifiedaccess_group, description must be 255 characters or less"
  }
}

variable "policy_document" {
  description = "The policy document that is associated with this resource"
  type        = string
  default     = null

  validation {
    condition     = var.policy_document == null || can(jsondecode(var.policy_document))
    error_message = "resource_aws_verifiedaccess_group, policy_document must be a valid JSON policy document"
  }
}

variable "sse_configuration" {
  description = "Configuration block to use KMS keys for server-side encryption"
  type = object({
    customer_managed_key_enabled = optional(bool)
    kms_key_arn                  = optional(string)
  })
  default = null

  validation {
    condition = var.sse_configuration == null || (
      var.sse_configuration.kms_key_arn == null ||
      can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.sse_configuration.kms_key_arn))
    )
    error_message = "resource_aws_verifiedaccess_group, kms_key_arn must be a valid KMS key ARN"
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

