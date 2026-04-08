variable "name" {
  description = "Name of the component"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_imagebuilder_component, name must not be empty."
  }
}

variable "platform" {
  description = "Platform of the component"
  type        = string

  validation {
    condition     = contains(["Linux", "Windows"], var.platform)
    error_message = "resource_aws_imagebuilder_component, platform must be either 'Linux' or 'Windows'."
  }
}

variable "component_version" {
  description = "Version of the component"
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.component_version))
    error_message = "resource_aws_imagebuilder_component, version must follow semantic versioning format (e.g., '1.0.0')."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "change_description" {
  description = "Change description of the component"
  type        = string
  default     = null
}

variable "data" {
  description = "Inline YAML string with data of the component. Exactly one of data and uri can be specified"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the component"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key used to encrypt the component"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}$", var.kms_key_id))
    error_message = "resource_aws_imagebuilder_component, kms_key_id must be a valid KMS key ARN."
  }
}

variable "skip_destroy" {
  description = "Whether to retain the old version when the resource is destroyed or replacement is necessary. Defaults to false"
  type        = bool
  default     = false
}

variable "supported_os_versions" {
  description = "Set of Operating Systems (OS) supported by the component"
  type        = set(string)
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags for the component"
  type        = map(string)
  default     = {}
}

variable "uri" {
  description = "S3 URI with data of the component. Exactly one of data and uri can be specified"
  type        = string
  default     = null

  validation {
    condition     = var.uri == null || can(regex("^s3://[a-z0-9.-]+/.+$", var.uri))
    error_message = "resource_aws_imagebuilder_component, uri must be a valid S3 URI (s3://bucket/key)."
  }
}