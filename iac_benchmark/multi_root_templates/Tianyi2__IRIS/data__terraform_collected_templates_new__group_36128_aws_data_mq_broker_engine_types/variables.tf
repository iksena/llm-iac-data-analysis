variable "engine_type" {
  description = "MQ engine type to return version details for"
  type        = string
  default     = null

  validation {
    condition     = var.engine_type == null || contains(["ACTIVEMQ", "RABBITMQ"], var.engine_type)
    error_message = "data_aws_mq_broker_engine_types, engine_type must be either 'ACTIVEMQ' or 'RABBITMQ'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_mq_broker_engine_types, region must be a valid AWS region identifier."
  }
}