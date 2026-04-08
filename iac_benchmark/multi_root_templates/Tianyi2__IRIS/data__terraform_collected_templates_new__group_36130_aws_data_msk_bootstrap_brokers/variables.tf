variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_msk_bootstrap_brokers, region must be a valid AWS region format or null."
  }
}

variable "cluster_arn" {
  description = "ARN of the cluster the nodes belong to."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]{12}:cluster/.+", var.cluster_arn))
    error_message = "data_aws_msk_bootstrap_brokers, cluster_arn must be a valid MSK cluster ARN."
  }
}