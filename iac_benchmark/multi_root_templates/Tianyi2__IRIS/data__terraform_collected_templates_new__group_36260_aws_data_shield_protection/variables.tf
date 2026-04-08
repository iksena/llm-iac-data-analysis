variable "protection_id" {
  description = "Unique identifier for the protection."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "ARN (Amazon Resource Name) of the resource being protected."
  type        = string
  default     = null
}