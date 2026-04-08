variable "name" {
  description = "Name of the Cross Account Attachment."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, name must not be empty."
  }
}

variable "principals" {
  description = "List of AWS account IDs that are allowed to associate resources with the accelerator."
  type        = list(string)
  default     = null

  validation {
    condition = var.principals == null || (
      var.principals != null &&
      length(var.principals) > 0 &&
      alltrue([
        for principal in var.principals :
        can(regex("^[0-9]{12}$", principal))
      ])
    )
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, principals must be a list of 12-digit AWS account IDs."
  }
}

variable "resources" {
  description = "List of resources to be associated with the accelerator."
  type = list(object({
    cidr_block  = optional(string)
    endpoint_id = optional(string)
    region      = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for resource in var.resources :
      (resource.cidr_block != null && resource.endpoint_id == null) ||
      (resource.cidr_block == null && resource.endpoint_id != null) ||
      (resource.cidr_block == null && resource.endpoint_id == null)
    ])
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, resources cannot specify both cidr_block and endpoint_id simultaneously."
  }

  validation {
    condition = alltrue([
      for resource in var.resources :
      resource.cidr_block == null || can(cidrhost(resource.cidr_block, 0))
    ])
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, resources cidr_block must be a valid CIDR format."
  }

  validation {
    condition = alltrue([
      for resource in var.resources :
      resource.endpoint_id == null || can(regex("^arn:aws:", resource.endpoint_id))
    ])
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, resources endpoint_id must be a valid AWS ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags :
      length(key) <= 128 && length(value) <= 256
    ])
    error_message = "resource_aws_globalaccelerator_cross_account_attachment, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}

