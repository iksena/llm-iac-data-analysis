variable "data" {
  description = "Broker configuration in XML format for ActiveMQ or Cuttlefish format for RabbitMQ"
  type        = string
}

variable "engine_type" {
  description = "Type of broker engine"
  type        = string
  validation {
    condition     = contains(["ActiveMQ", "RabbitMQ"], var.engine_type)
    error_message = "resource_aws_mq_configuration, engine_type must be either 'ActiveMQ' or 'RabbitMQ'."
  }
}

variable "engine_version" {
  description = "Version of the broker engine"
  type        = string
}

variable "name" {
  description = "Name of the configuration"
  type        = string
}

variable "authentication_strategy" {
  description = "Authentication strategy associated with the configuration"
  type        = string
  default     = null
  validation {
    condition     = var.authentication_strategy == null || contains(["simple", "ldap"], var.authentication_strategy)
    error_message = "resource_aws_mq_configuration, authentication_strategy must be either 'simple' or 'ldap'."
  }
}

variable "description" {
  description = "Description of the configuration"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}