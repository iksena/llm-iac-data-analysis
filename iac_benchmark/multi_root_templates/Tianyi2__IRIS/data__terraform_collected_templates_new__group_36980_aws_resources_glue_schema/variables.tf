variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "schema_name" {
  description = "The Name of the schema"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.schema_name))
    error_message = "resource_aws_glue_schema, schema_name must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "registry_arn" {
  description = "The ARN of the Glue Registry to create the schema in"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:glue:", var.registry_arn))
    error_message = "resource_aws_glue_schema, registry_arn must be a valid AWS Glue Registry ARN."
  }
}

variable "data_format" {
  description = "The data format of the schema definition"
  type        = string

  validation {
    condition     = contains(["AVRO", "JSON", "PROTOBUF"], var.data_format)
    error_message = "resource_aws_glue_schema, data_format must be one of: AVRO, JSON, PROTOBUF."
  }
}

variable "compatibility" {
  description = "The compatibility mode of the schema"
  type        = string

  validation {
    condition     = contains(["NONE", "DISABLED", "BACKWARD", "BACKWARD_ALL", "FORWARD", "FORWARD_ALL", "FULL", "FULL_ALL"], var.compatibility)
    error_message = "resource_aws_glue_schema, compatibility must be one of: NONE, DISABLED, BACKWARD, BACKWARD_ALL, FORWARD, FORWARD_ALL, FULL, FULL_ALL."
  }
}

variable "schema_definition" {
  description = "The schema definition using the data_format setting for schema_name"
  type        = string

  validation {
    condition     = length(var.schema_definition) > 0
    error_message = "resource_aws_glue_schema, schema_definition cannot be empty."
  }
}

variable "description" {
  description = "A description of the schema"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}