variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "preferred_versions" {
  description = "Ordered list of preferred Kafka versions. The first match in this list will be returned. Either preferred_versions or version must be set."
  type        = list(string)
  default     = null
}

variable "kafka_version" {
  description = "Version of MSK Kafka. For example 2.4.1.1 or 2.2.1 etc. Either preferred_versions or version must be set."
  type        = string
  default     = null
}