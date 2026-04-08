variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]{12}:cluster/.*", var.cluster_arn))
    error_message = "resource_aws_msk_scram_secret_association, cluster_arn must be a valid MSK cluster ARN in the format 'arn:aws:kafka:region:account-id:cluster/cluster-name/uuid'."
  }
}

variable "secret_arn_list" {
  description = "List of AWS Secrets Manager secret ARNs."
  type        = list(string)

  validation {
    condition     = length(var.secret_arn_list) > 0
    error_message = "resource_aws_msk_scram_secret_association, secret_arn_list must contain at least one secret ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.secret_arn_list :
      can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:.*", arn))
    ])
    error_message = "resource_aws_msk_scram_secret_association, secret_arn_list must contain valid AWS Secrets Manager secret ARNs in the format 'arn:aws:secretsmanager:region:account-id:secret:secret-name'."
  }
}