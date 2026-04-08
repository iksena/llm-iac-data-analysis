variable "broker_id" {
  description = "Unique ID of the MQ broker"
  type        = string
  default     = null
}

variable "broker_name" {
  description = "Unique name of the MQ broker"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}