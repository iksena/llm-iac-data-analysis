variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "engine" {
  description = "DB engine. Default: docdb"
  type        = string
  default     = "docdb"
}

variable "engine_version" {
  description = "Version of the DB engine."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "DB instance class. Examples of classes are db.r5.12xlarge, db.r5.24xlarge, db.r5.2xlarge, db.r5.4xlarge, db.r5.large, db.r5.xlarge, and db.t3.medium. (Conflicts with preferred_instance_classes.)"
  type        = string
  default     = null

  validation {
    condition     = var.instance_class == null || var.preferred_instance_classes == null
    error_message = "data_aws_docdb_orderable_db_instance, instance_class: instance_class and preferred_instance_classes cannot be specified at the same time."
  }
}

variable "license_model" {
  description = "License model. Default: na"
  type        = string
  default     = "na"
}

variable "preferred_instance_classes" {
  description = "Ordered list of preferred DocumentDB DB instance classes. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned. (Conflicts with instance_class.)"
  type        = list(string)
  default     = null
}

variable "vpc" {
  description = "Enable to show only VPC."
  type        = bool
  default     = null
}