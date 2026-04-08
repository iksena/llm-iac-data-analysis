variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_db_instance_role_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}

variable "db_instance_identifier" {
  description = "DB Instance Identifier to associate with the IAM Role."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.db_instance_identifier)) && length(var.db_instance_identifier) >= 1 && length(var.db_instance_identifier) <= 63
    error_message = "resource_aws_db_instance_role_association, db_instance_identifier must be between 1 and 63 characters, start with a letter, and contain only alphanumeric characters and hyphens."
  }
}

variable "feature_name" {
  description = "Name of the feature for association. This can be found in the AWS documentation relevant to the integration or a full list is available in the SupportedFeatureNames list returned by AWS CLI rds describe-db-engine-versions."
  type        = string

  validation {
    condition     = length(var.feature_name) > 0
    error_message = "resource_aws_db_instance_role_association, feature_name cannot be empty."
  }
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role to associate with the DB Instance."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:role/.+$", var.role_arn))
    error_message = "resource_aws_db_instance_role_association, role_arn must be a valid IAM role ARN format."
  }
}