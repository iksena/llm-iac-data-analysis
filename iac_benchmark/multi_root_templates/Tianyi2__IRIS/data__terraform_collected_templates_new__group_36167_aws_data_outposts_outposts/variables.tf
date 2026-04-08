variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability Zone name."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "Availability Zone identifier."
  type        = string
  default     = null
}

variable "site_id" {
  description = "Site identifier."
  type        = string
  default     = null
}

variable "owner_id" {
  description = "AWS Account identifier of the Outpost owner."
  type        = string
  default     = null
}