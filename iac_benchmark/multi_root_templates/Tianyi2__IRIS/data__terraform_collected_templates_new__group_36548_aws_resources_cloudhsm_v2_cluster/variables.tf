variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_backup_identifier" {
  description = "ID of Cloud HSM v2 cluster backup to be restored."
  type        = string
  default     = null
}

variable "hsm_type" {
  description = "The type of HSM module in the cluster. Currently, hsm1.medium and hsm2m.medium are supported."
  type        = string

  validation {
    condition     = contains(["hsm1.medium", "hsm2m.medium"], var.hsm_type)
    error_message = "resource_aws_cloudhsm_v2_cluster, hsm_type must be either 'hsm1.medium' or 'hsm2m.medium'."
  }
}

variable "subnet_ids" {
  description = "The IDs of subnets in which cluster will operate."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_cloudhsm_v2_cluster, subnet_ids must contain at least one subnet ID."
  }
}

variable "mode" {
  description = "The mode to use in the cluster. The allowed values are FIPS and NON_FIPS. This field is required if hsm_type is hsm2m.medium."
  type        = string
  default     = null

  validation {
    condition     = var.mode == null || contains(["FIPS", "NON_FIPS"], var.mode)
    error_message = "resource_aws_cloudhsm_v2_cluster, mode must be either 'FIPS' or 'NON_FIPS'."
  }

  validation {
    condition     = var.hsm_type != "hsm2m.medium" || var.mode != null
    error_message = "resource_aws_cloudhsm_v2_cluster, mode is required when hsm_type is 'hsm2m.medium'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}