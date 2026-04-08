variable "name" {
  description = "Name of the container service. Names must be of length 1 to 63, and be unique within each AWS Region in your Lightsail account."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 63
    error_message = "resource_aws_lightsail_container_service, name must be between 1 and 63 characters in length."
  }
}

variable "power" {
  description = "Power specification for the container service. The power specifies the amount of memory, the number of vCPUs, and the monthly price of each node of the container service."
  type        = string

  validation {
    condition     = contains(["nano", "micro", "small", "medium", "large", "xlarge"], var.power)
    error_message = "resource_aws_lightsail_container_service, power must be one of: nano, micro, small, medium, large, xlarge."
  }
}

variable "scale" {
  description = "Scale specification for the container service. The scale specifies the allocated compute nodes of the container service."
  type        = number

  validation {
    condition     = var.scale > 0
    error_message = "resource_aws_lightsail_container_service, scale must be greater than 0."
  }
}

variable "is_disabled" {
  description = "Whether to disable the container service."
  type        = bool
  default     = false
}

variable "private_registry_access" {
  description = "Configuration for the container service to access private container image repositories, such as Amazon Elastic Container Registry (Amazon ECR) private repositories."
  type = object({
    ecr_image_puller_role = optional(object({
      is_active = optional(bool, false)
    }))
  })
  default = null
}

variable "public_domain_names" {
  description = "Public domain names to use with the container service. You can specify up to four public domain names for a container service."
  type = object({
    certificate = list(object({
      certificate_name = string
      domain_names     = list(string)
    }))
  })
  default = null

  validation {
    condition = var.public_domain_names == null || (
      var.public_domain_names != null &&
      length(var.public_domain_names.certificate) <= 4
    )
    error_message = "resource_aws_lightsail_container_service, public_domain_names can specify up to four certificates."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value."
  type        = map(string)
  default     = {}
}