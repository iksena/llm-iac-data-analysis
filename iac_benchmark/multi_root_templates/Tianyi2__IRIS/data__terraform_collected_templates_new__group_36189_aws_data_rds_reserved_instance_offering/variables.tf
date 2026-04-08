variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "db_instance_class" {
  description = "DB instance class for the reserved DB instance"
  type        = string

  validation {
    condition     = can(regex("^db\\.", var.db_instance_class))
    error_message = "data_aws_rds_reserved_instance_offering, db_instance_class must start with 'db.'."
  }
}

variable "duration" {
  description = "Duration of the reservation in years or seconds"
  type        = number

  validation {
    condition     = contains([1, 3, 31536000, 94608000], var.duration)
    error_message = "data_aws_rds_reserved_instance_offering, duration must be one of: 1, 3, 31536000, 94608000."
  }
}

variable "multi_az" {
  description = "Whether the reservation applies to Multi-AZ deployments"
  type        = bool
}

variable "offering_type" {
  description = "Offering type of this reserved DB instance"
  type        = string

  validation {
    condition     = contains(["No Upfront", "Partial Upfront", "All Upfront"], var.offering_type)
    error_message = "data_aws_rds_reserved_instance_offering, offering_type must be one of: 'No Upfront', 'Partial Upfront', 'All Upfront'."
  }
}

variable "product_description" {
  description = "Description of the reserved DB instance"
  type        = string

  validation {
    condition     = contains(["postgresql", "aurora-postgresql", "mysql", "aurora-mysql", "mariadb"], var.product_description)
    error_message = "data_aws_rds_reserved_instance_offering, product_description must be one of: 'postgresql', 'aurora-postgresql', 'mysql', 'aurora-mysql', 'mariadb'."
  }
}