variable "regions" {
  description = "The replication set's regions"
  type = list(object({
    name        = string
    kms_key_arn = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.regions) > 0
    error_message = "resource_aws_ssmincidents_replication_set, regions - At least one region must be specified."
  }

  validation {
    condition = alltrue([
      for region in var.regions : can(regex("^[a-z0-9-]+$", region.name))
    ])
    error_message = "resource_aws_ssmincidents_replication_set, regions - Region names must be valid AWS region identifiers."
  }

  validation {
    condition = alltrue([
      for region in var.regions :
      region.kms_key_arn == null || can(regex("^arn:aws:kms:", region.kms_key_arn))
    ])
    error_message = "resource_aws_ssmincidents_replication_set, regions - KMS key ARN must be a valid KMS key ARN when specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_ssmincidents_replication_set, tags - Tag keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_ssmincidents_replication_set, tags - Tag values must be between 0 and 256 characters."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "120m")
    update = optional(string, "120m")
    delete = optional(string, "120m")
  })
  default = {
    create = "120m"
    update = "120m"
    delete = "120m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_ssmincidents_replication_set, timeouts - Timeout values must be valid duration strings (e.g., '120m', '2h', '300s')."
  }
}