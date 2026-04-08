variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "id" {
  description = "ID of the collection."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the collection."
  type        = string
  default     = null
}