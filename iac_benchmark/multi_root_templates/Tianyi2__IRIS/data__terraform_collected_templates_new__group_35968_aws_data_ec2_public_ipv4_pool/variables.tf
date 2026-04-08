variable "pool_id" {
  description = "AWS resource IDs of a public IPv4 pool (as a string) for which this data source will fetch detailed information"
  type        = string

  validation {
    condition     = can(regex("^ipv4pool-", var.pool_id))
    error_message = "data_aws_ec2_public_ipv4_pool, pool_id must be a valid IPv4 pool ID starting with 'ipv4pool-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_public_ipv4_pool, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}