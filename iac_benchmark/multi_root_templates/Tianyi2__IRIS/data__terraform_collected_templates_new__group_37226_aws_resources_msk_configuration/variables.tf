variable "name" {
  description = "Name of the configuration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_msk_configuration, name must not be empty."
  }
}

variable "description" {
  description = "Description of the configuration"
  type        = string
  default     = null
}

variable "kafka_versions" {
  description = "List of Apache Kafka versions which can use this configuration"
  type        = list(string)
  default     = null

  validation {
    condition = var.kafka_versions == null || (
      length(var.kafka_versions) > 0 &&
      alltrue([for v in var.kafka_versions : can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", v))])
    )
    error_message = "resource_aws_msk_configuration, kafka_versions must be a list of valid version strings in format 'x.y.z'."
  }
}

variable "server_properties" {
  description = "Contents of the server.properties file. Supported properties are documented in the MSK Developer Guide"
  type        = string

  validation {
    condition     = length(var.server_properties) > 0
    error_message = "resource_aws_msk_configuration, server_properties must not be empty."
  }
}