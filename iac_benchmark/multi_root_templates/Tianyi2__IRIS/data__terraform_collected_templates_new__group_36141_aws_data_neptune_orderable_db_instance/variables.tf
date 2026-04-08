variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "engine" {
  type        = string
  default     = "neptune"
  description = "DB engine."

  validation {
    condition     = can(regex("^(neptune)$", var.engine))
    error_message = "data_aws_neptune_orderable_db_instance, engine must be 'neptune'."
  }
}

variable "engine_version" {
  type        = string
  default     = null
  description = "Version of the DB engine. For example, 1.0.1.0, 1.0.1.2, 1.0.2.2, and 1.0.3.0."

  validation {
    condition     = var.engine_version == null || can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "data_aws_neptune_orderable_db_instance, engine_version must be in format X.X.X.X (e.g., 1.0.3.0)."
  }
}

variable "instance_class" {
  type        = string
  default     = null
  description = "DB instance class. Examples of classes are db.r5.large, db.r5.xlarge, db.r4.large, db.r5.4xlarge, db.r5.12xlarge, db.r4.xlarge, and db.t3.medium."

  validation {
    condition     = var.instance_class == null || can(regex("^db\\.[a-z0-9]+\\.[a-z0-9]+$", var.instance_class))
    error_message = "data_aws_neptune_orderable_db_instance, instance_class must be in format 'db.{family}.{size}' (e.g., db.r5.large)."
  }
}

variable "license_model" {
  type        = string
  default     = "amazon-license"
  description = "License model."

  validation {
    condition     = can(regex("^(amazon-license)$", var.license_model))
    error_message = "data_aws_neptune_orderable_db_instance, license_model must be 'amazon-license'."
  }
}

variable "preferred_instance_classes" {
  type        = list(string)
  default     = null
  description = "Ordered list of preferred Neptune DB instance classes. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned."

  validation {
    condition = var.preferred_instance_classes == null || alltrue([
      for class in var.preferred_instance_classes : can(regex("^db\\.[a-z0-9]+\\.[a-z0-9]+$", class))
    ])
    error_message = "data_aws_neptune_orderable_db_instance, preferred_instance_classes must contain valid instance class formats 'db.{family}.{size}' (e.g., db.r5.large)."
  }
}

variable "vpc" {
  type        = bool
  default     = null
  description = "Enable to show only VPC offerings."
}