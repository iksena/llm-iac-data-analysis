variable "data_set_id" {
  description = "ID of the dataset used in the ingestion"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.data_set_id))
    error_message = "resource_aws_quicksight_ingestion, data_set_id must be a valid dataset ID containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ingestion_id" {
  description = "ID for the ingestion"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.ingestion_id))
    error_message = "resource_aws_quicksight_ingestion, ingestion_id must be a valid ingestion ID containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ingestion_type" {
  description = "Type of ingestion to be created"
  type        = string

  validation {
    condition     = contains(["INCREMENTAL_REFRESH", "FULL_REFRESH"], var.ingestion_type)
    error_message = "resource_aws_quicksight_ingestion, ingestion_type must be either 'INCREMENTAL_REFRESH' or 'FULL_REFRESH'."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_ingestion, aws_account_id must be a 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_ingestion, region must be a valid AWS region name or null."
  }
}