variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_id" {
  description = "The ID of Cloud HSM v2 cluster to which HSM will be added."
  type        = string

  validation {
    condition     = length(var.cluster_id) > 0
    error_message = "resource_aws_cloudhsm_v2_hsm, cluster_id must not be empty."
  }
}

variable "subnet_id" {
  description = "The ID of subnet in which HSM module will be located. Conflicts with availability_zone."
  type        = string
  default     = null

  validation {
    condition = var.subnet_id == null || (
      var.subnet_id != null && length(var.subnet_id) > 0
    )
    error_message = "resource_aws_cloudhsm_v2_hsm, subnet_id must not be empty when provided."
  }
}

variable "availability_zone" {
  description = "The IDs of AZ in which HSM module will be located. Conflicts with subnet_id."
  type        = string
  default     = null

  validation {
    condition = var.availability_zone == null || (
      var.availability_zone != null && length(var.availability_zone) > 0
    )
    error_message = "resource_aws_cloudhsm_v2_hsm, availability_zone must not be empty when provided."
  }
}

variable "ip_address" {
  description = "The IP address of HSM module. Must be within the CIDR of selected subnet."
  type        = string
  default     = null

  validation {
    condition = var.ip_address == null || (
      var.ip_address != null && can(cidrhost("10.0.0.0/8", 0))
    )
    error_message = "resource_aws_cloudhsm_v2_hsm, ip_address must be a valid IP address when provided."
  }
}