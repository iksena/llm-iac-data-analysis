variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account" {
  description = "The Amazon Web Services account ID to grant access to."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account))
    error_message = "resource_aws_redshift_endpoint_authorization, account must be a 12-digit AWS account ID."
  }
}

variable "cluster_identifier" {
  description = "The cluster identifier of the cluster to grant access to."
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0
    error_message = "resource_aws_redshift_endpoint_authorization, cluster_identifier must not be empty."
  }
}

variable "force_delete" {
  description = "Indicates whether to force the revoke action. If true, the Redshift-managed VPC endpoints associated with the endpoint authorization are also deleted."
  type        = bool
  default     = false
}

variable "vpc_ids" {
  description = "The virtual private cloud (VPC) identifiers to grant access to. If none are specified all VPCs in shared account are allowed."
  type        = list(string)
  default     = null

  validation {
    condition = var.vpc_ids == null ? true : alltrue([
      for vpc_id in var.vpc_ids : can(regex("^vpc-[a-zA-Z0-9]+$", vpc_id))
    ])
    error_message = "resource_aws_redshift_endpoint_authorization, vpc_ids must be a list of valid VPC IDs starting with 'vpc-'."
  }
}