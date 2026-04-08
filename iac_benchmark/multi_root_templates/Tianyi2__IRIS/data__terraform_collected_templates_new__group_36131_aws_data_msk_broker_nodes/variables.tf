variable "cluster_arn" {
  description = "ARN of the cluster the nodes belong to"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:", var.cluster_arn))
    error_message = "data_aws_msk_broker_nodes, cluster_arn must be a valid MSK cluster ARN starting with 'arn:aws:kafka:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_msk_broker_nodes, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}