variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the function."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_glue_user_defined_function, name must not be empty."
  }
}

variable "catalog_id" {
  description = "ID of the Glue Catalog to create the function in. If omitted, this defaults to the AWS Account ID."
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the Database to create the Function."
  type        = string

  validation {
    condition     = length(var.database_name) > 0
    error_message = "resource_aws_glue_user_defined_function, database_name must not be empty."
  }
}

variable "class_name" {
  description = "The Java class that contains the function code."
  type        = string

  validation {
    condition     = length(var.class_name) > 0
    error_message = "resource_aws_glue_user_defined_function, class_name must not be empty."
  }
}

variable "owner_name" {
  description = "The owner of the function."
  type        = string

  validation {
    condition     = length(var.owner_name) > 0
    error_message = "resource_aws_glue_user_defined_function, owner_name must not be empty."
  }
}

variable "owner_type" {
  description = "The owner type. Can be one of USER, ROLE, and GROUP."
  type        = string

  validation {
    condition     = contains(["USER", "ROLE", "GROUP"], var.owner_type)
    error_message = "resource_aws_glue_user_defined_function, owner_type must be one of USER, ROLE, or GROUP."
  }
}

variable "resource_uris" {
  description = "The configuration block for Resource URIs."
  type = list(object({
    resource_type = string
    uri           = string
  }))
  default = null

  validation {
    condition = var.resource_uris == null ? true : alltrue([
      for uri in var.resource_uris : contains(["JAR", "FILE", "ARCHIVE"], uri.resource_type)
    ])
    error_message = "resource_aws_glue_user_defined_function, resource_uris resource_type must be one of JAR, FILE, or ARCHIVE."
  }

  validation {
    condition = var.resource_uris == null ? true : alltrue([
      for uri in var.resource_uris : length(uri.uri) > 0
    ])
    error_message = "resource_aws_glue_user_defined_function, resource_uris uri must not be empty."
  }
}