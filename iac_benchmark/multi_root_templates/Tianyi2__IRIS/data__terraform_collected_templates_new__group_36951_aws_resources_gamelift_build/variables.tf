variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the build"
  type        = string
}

variable "operating_system" {
  description = "Operating system that the game server binaries are built to run on."
  type        = string

  validation {
    condition = contains([
      "WINDOWS_2012",
      "AMAZON_LINUX",
      "AMAZON_LINUX_2",
      "WINDOWS_2016",
      "AMAZON_LINUX_2023"
    ], var.operating_system)
    error_message = "resource_aws_gamelift_build, operating_system must be one of: WINDOWS_2012, AMAZON_LINUX, AMAZON_LINUX_2, WINDOWS_2016, AMAZON_LINUX_2023"
  }
}

variable "storage_location" {
  description = "Information indicating where your game build files are stored"
  type = object({
    bucket         = string
    key            = string
    role_arn       = string
    object_version = optional(string)
  })
}

variable "build_version" {
  description = "Version that is associated with this build"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}