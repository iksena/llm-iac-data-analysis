variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_db_instance, region must be a valid AWS region identifier."
  }
}

variable "db_instance_identifier" {
  description = "Name of the RDS instance."
  type        = string
  default     = null

  validation {
    condition     = var.db_instance_identifier == null || can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.db_instance_identifier))
    error_message = "data_aws_db_instance, db_instance_identifier must be a valid RDS instance identifier."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired instance."
  type        = map(string)
  default     = null

  validation {
    condition = var.tags == null || alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "data_aws_db_instance, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}