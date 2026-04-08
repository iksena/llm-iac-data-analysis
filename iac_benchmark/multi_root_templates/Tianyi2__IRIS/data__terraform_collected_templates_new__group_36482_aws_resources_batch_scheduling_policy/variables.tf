variable "name" {
  description = "Specifies the name of the scheduling policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_batch_scheduling_policy, name must not be empty."
  }
}

variable "fair_share_policy" {
  description = "A fairshare policy block specifies the compute_reservation, share_decay_seconds, and share_distribution of the scheduling policy."
  type = object({
    compute_reservation = optional(number)
    share_decay_seconds = optional(number)
    share_distribution = optional(list(object({
      share_identifier = string
      weight_factor    = optional(number)
    })))
  })
  default = null

  validation {
    condition = var.fair_share_policy == null || (
      var.fair_share_policy.compute_reservation == null ||
      (var.fair_share_policy.compute_reservation >= 0 && var.fair_share_policy.compute_reservation <= 99)
    )
    error_message = "resource_aws_batch_scheduling_policy, compute_reservation must be between 0 and 99."
  }

  validation {
    condition = var.fair_share_policy == null || (
      var.fair_share_policy.share_decay_seconds == null ||
      var.fair_share_policy.share_decay_seconds > 0
    )
    error_message = "resource_aws_batch_scheduling_policy, share_decay_seconds must be greater than 0."
  }

  validation {
    condition = var.fair_share_policy == null || var.fair_share_policy.share_distribution == null || (
      alltrue([
        for sd in var.fair_share_policy.share_distribution :
        length(sd.share_identifier) > 0
      ])
    )
    error_message = "resource_aws_batch_scheduling_policy, share_identifier must not be empty."
  }

  validation {
    condition = var.fair_share_policy == null || var.fair_share_policy.share_distribution == null || (
      alltrue([
        for sd in var.fair_share_policy.share_distribution :
        sd.weight_factor == null || (sd.weight_factor >= 0 && sd.weight_factor <= 1)
      ])
    )
    error_message = "resource_aws_batch_scheduling_policy, weight_factor must be between 0 and 1."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}