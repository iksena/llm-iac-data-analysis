variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "db_cluster_identifier" {
  type        = string
  description = "DB Cluster Identifier to associate with the IAM Role."

  validation {
    condition     = length(var.db_cluster_identifier) > 0
    error_message = "resource_aws_rds_cluster_role_association, db_cluster_identifier must not be empty."
  }
}

variable "feature_name" {
  type        = string
  default     = null
  description = "Name of the feature for association. This can be found in the AWS documentation relevant to the integration or a full list is available in the SupportedFeatureNames list returned by AWS CLI rds describe-db-engine-versions."
}

variable "role_arn" {
  type        = string
  description = "Amazon Resource Name (ARN) of the IAM Role to associate with the DB Cluster."

  validation {
    condition     = can(regex("^arn:aws:iam::\\d{12}:role/.+", var.role_arn))
    error_message = "resource_aws_rds_cluster_role_association, role_arn must be a valid IAM Role ARN."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default     = null
  description = "Configuration options for timeouts."
}