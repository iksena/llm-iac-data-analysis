variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_msk_single_scram_secret_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "cluster_arn" {
  type        = string
  description = "Amazon Resource Name (ARN) of the MSK cluster."

  validation {
    condition     = can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]+:cluster/.+", var.cluster_arn))
    error_message = "resource_aws_msk_single_scram_secret_association, cluster_arn must be a valid MSK cluster ARN."
  }
}

variable "secret_arn" {
  type        = string
  description = "AWS Secrets Manager secret ARN."

  validation {
    condition     = can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]+:secret:.+", var.secret_arn))
    error_message = "resource_aws_msk_single_scram_secret_association, secret_arn must be a valid Secrets Manager secret ARN."
  }
}