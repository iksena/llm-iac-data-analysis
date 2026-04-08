variable "engine_type" {
  description = "Filter response by engine type"
  type        = string
  default     = null

  validation {
    condition     = var.engine_type == null || can(regex("^(ACTIVEMQ|RABBITMQ)$", var.engine_type))
    error_message = "data_aws_mq_broker_instance_type_offerings, engine_type must be either 'ACTIVEMQ' or 'RABBITMQ' or null."
  }
}

variable "host_instance_type" {
  description = "Filter response by host instance type"
  type        = string
  default     = null

  validation {
    condition     = var.host_instance_type == null || can(regex("^mq\\.", var.host_instance_type))
    error_message = "data_aws_mq_broker_instance_type_offerings, host_instance_type must start with 'mq.' or be null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_mq_broker_instance_type_offerings, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "storage_type" {
  description = "Filter response by storage type"
  type        = string
  default     = null

  validation {
    condition     = var.storage_type == null || can(regex("^(EBS|EFS)$", var.storage_type))
    error_message = "data_aws_mq_broker_instance_type_offerings, storage_type must be either 'EBS' or 'EFS' or null."
  }
}