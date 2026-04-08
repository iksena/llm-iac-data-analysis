variable "table_name" {
  description = "The name of the table containing the requested item"
  type        = string

  validation {
    condition     = length(var.table_name) > 0
    error_message = "data_aws_dynamodb_table_item, table_name must not be empty."
  }
}

variable "key" {
  description = "A map of attribute names to AttributeValue objects, representing the primary key of the item to retrieve. For the primary key, you must provide all of the attributes. For example, with a simple primary key, you only need to provide a value for the partition key. For a composite primary key, you must provide values for both the partition key and the sort key"
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "data_aws_dynamodb_table_item, key must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.key))
    error_message = "data_aws_dynamodb_table_item, key must be valid JSON."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "expression_attribute_names" {
  description = "One or more substitution tokens for attribute names in an expression. Use the # character in an expression to dereference an attribute name"
  type        = map(string)
  default     = null
}

variable "projection_expression" {
  description = "A string that identifies one or more attributes to retrieve from the table. These attributes can include scalars, sets, or elements of a JSON document. The attributes in the expression must be separated by commas. If no attribute names are specified, then all attributes are returned. If any of the requested attributes are not found, they do not appear in the result"
  type        = string
  default     = null
}