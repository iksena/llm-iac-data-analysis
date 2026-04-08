variable "instance_type" {
  type        = string
  description = "Instance type to use when launching the image builder."
}

variable "name" {
  type        = string
  description = "Unique name for the image builder."
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "access_endpoint" {
  type = list(object({
    endpoint_type = string
    vpce_id       = optional(string)
  }))
  description = "Set of interface VPC endpoint (interface endpoint) objects. Maximum of 4."
  default     = []
  validation {
    condition     = length(var.access_endpoint) <= 4
    error_message = "resource_aws_appstream_image_builder, access_endpoint: maximum of 4 access endpoints are allowed."
  }
}

variable "appstream_agent_version" {
  type        = string
  description = "Version of the AppStream 2.0 agent to use for this image builder."
  default     = null
}

variable "description" {
  type        = string
  description = "Description to display."
  default     = null
}

variable "display_name" {
  type        = string
  description = "Human-readable friendly name for the AppStream image builder."
  default     = null
}

variable "domain_join_info" {
  type = object({
    directory_name                         = optional(string)
    organizational_unit_distinguished_name = optional(string)
  })
  description = "Configuration block for the name of the directory and organizational unit (OU) to use to join the image builder to a Microsoft Active Directory domain."
  default     = null
}

variable "enable_default_internet_access" {
  type        = bool
  description = "Enables or disables default internet access for the image builder."
  default     = null
}

variable "iam_role_arn" {
  type        = string
  description = "ARN of the IAM role to apply to the image builder."
  default     = null
}

variable "image_arn" {
  type        = string
  description = "ARN of the public, private, or shared image to use."
  default     = null
}

variable "image_name" {
  type        = string
  description = "Name of the image used to create the image builder."
  default     = null
}

variable "vpc_config" {
  type = object({
    security_group_ids = optional(list(string))
    subnet_ids         = optional(list(string))
  })
  description = "Configuration block for the VPC configuration for the image builder."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the instance."
  default     = {}
}