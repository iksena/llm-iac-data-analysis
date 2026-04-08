variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the data catalog. The catalog name must be unique for the AWS account and can use a maximum of 128 alphanumeric, underscore, at sign, or hyphen characters."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_@-]{1,128}$", var.name))
    error_message = "resource_aws_athena_data_catalog, name must be 1-128 characters and contain only alphanumeric, underscore, at sign, or hyphen characters."
  }
}

variable "type" {
  description = "Type of data catalog: LAMBDA for a federated catalog, GLUE for AWS Glue Catalog, or HIVE for an external hive metastore."
  type        = string

  validation {
    condition     = contains(["LAMBDA", "GLUE", "HIVE"], var.type)
    error_message = "resource_aws_athena_data_catalog, type must be one of: LAMBDA, GLUE, or HIVE."
  }
}

variable "parameters" {
  description = "Key value pairs that specifies the Lambda function or functions to use for the data catalog. The mapping used depends on the catalog type."
  type        = map(string)
}

variable "description" {
  description = "Description of the data catalog."
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}