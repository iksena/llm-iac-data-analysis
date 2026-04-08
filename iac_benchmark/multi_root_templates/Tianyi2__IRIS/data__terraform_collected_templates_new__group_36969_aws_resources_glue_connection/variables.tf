variable "name" {
  description = "Name of the connection."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "ID of the Data Catalog in which to create the connection. If none is supplied, the AWS account ID is used by default."
  type        = string
  default     = null
}

variable "athena_properties" {
  description = "Map of key-value pairs used as connection properties specific to the Athena compute environment."
  type        = map(string)
  default     = null
}

variable "connection_properties" {
  description = "Map of key-value pairs used as parameters for this connection. For more information, see the AWS Documentation."
  type        = map(string)
  default     = null
}

variable "connection_type" {
  description = "Type of the connection. Valid values: AZURECOSMOS, AZURESQL, BIGQUERY, CUSTOM, DYNAMODB, JDBC, KAFKA, MARKETPLACE, MONGODB, NETWORK, OPENSEARCH, SNOWFLAKE. Defaults to JDBC."
  type        = string
  default     = "JDBC"

  validation {
    condition = contains([
      "AZURECOSMOS",
      "AZURESQL",
      "BIGQUERY",
      "CUSTOM",
      "DYNAMODB",
      "JDBC",
      "KAFKA",
      "MARKETPLACE",
      "MONGODB",
      "NETWORK",
      "OPENSEARCH",
      "SNOWFLAKE"
    ], var.connection_type)
    error_message = "resource_aws_glue_connection, connection_type must be one of: AZURECOSMOS, AZURESQL, BIGQUERY, CUSTOM, DYNAMODB, JDBC, KAFKA, MARKETPLACE, MONGODB, NETWORK, OPENSEARCH, SNOWFLAKE."
  }
}

variable "description" {
  description = "Description of the connection."
  type        = string
  default     = null
}

variable "match_criteria" {
  description = "List of criteria that can be used in selecting this connection."
  type        = list(string)
  default     = null
}

variable "physical_connection_requirements" {
  description = "Map of physical connection requirements, such as VPC and SecurityGroup."
  type = object({
    availability_zone      = optional(string)
    security_group_id_list = optional(list(string))
    subnet_id              = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}