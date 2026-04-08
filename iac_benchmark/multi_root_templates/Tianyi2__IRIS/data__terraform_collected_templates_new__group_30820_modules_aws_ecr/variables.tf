variable "name" {
  type = string
  description = "(Required) Name of the repository."
}

variable "image_tag_mutability" {
  type = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default = false
}

variable "tags" {
  type = map
  description = "(Optional) A map of tags to assign to the resource. "
  default = {}
}

variable "policy" {
  type = string
  description = "(Optional) Lifecycle policy of ECR Images."
  default = null
}

variable "expiration_days" {
  type = number
  description = "(Optional) image older than ecr_expiration_days will be deleted. Default is 7"
  default = 7
}

variable "enable_lifecycle_expiration_policy" {
  type = bool
  description = "(Optional) set true if you want to delete images older than expiration_days"
  default = false
}