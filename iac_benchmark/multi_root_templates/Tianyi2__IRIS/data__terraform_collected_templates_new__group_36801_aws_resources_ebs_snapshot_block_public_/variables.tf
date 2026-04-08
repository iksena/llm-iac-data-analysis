variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "state" {
  description = "The mode in which to enable 'Block public access for snapshots' for the region."
  type        = string

  validation {
    condition = contains([
      "block-all-sharing",
      "block-new-sharing",
      "unblocked"
    ], var.state)
    error_message = "resource_aws_ebs_snapshot_block_public_access, state must be one of: block-all-sharing, block-new-sharing, unblocked."
  }
}