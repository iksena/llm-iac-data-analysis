variable "name" {
  description = "Name of the product."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_servicecatalog_product, name must not be empty."
  }
}

variable "owner" {
  description = "Owner of the product."
  type        = string

  validation {
    condition     = length(var.owner) > 0
    error_message = "resource_aws_servicecatalog_product, owner must not be empty."
  }
}

variable "type" {
  description = "Type of product."
  type        = string

  validation {
    condition     = length(var.type) > 0
    error_message = "resource_aws_servicecatalog_product, type must not be empty."
  }
}

variable "provisioning_artifact_parameters" {
  description = "Configuration block for provisioning artifact (i.e., version) parameters."
  type = object({
    description                 = optional(string)
    disable_template_validation = optional(bool)
    name                        = optional(string)
    template_physical_id        = optional(string)
    template_url                = optional(string)
    type                        = optional(string)
  })

  validation {
    condition = (
      (var.provisioning_artifact_parameters.template_physical_id != null && var.provisioning_artifact_parameters.template_url == null) ||
      (var.provisioning_artifact_parameters.template_physical_id == null && var.provisioning_artifact_parameters.template_url != null)
    )
    error_message = "resource_aws_servicecatalog_product, provisioning_artifact_parameters must specify either template_physical_id or template_url, but not both."
  }

  validation {
    condition     = var.provisioning_artifact_parameters.name == null || can(regex("^[^\\s]+$", var.provisioning_artifact_parameters.name))
    error_message = "resource_aws_servicecatalog_product, provisioning_artifact_parameters name cannot contain spaces."
  }

  validation {
    condition     = var.provisioning_artifact_parameters.template_physical_id == null || can(regex("^arn:[^:]*:cloudformation:[^:]*:[^:]*:stack/[^/]*/[^/]*$", var.provisioning_artifact_parameters.template_physical_id))
    error_message = "resource_aws_servicecatalog_product, provisioning_artifact_parameters template_physical_id must be a valid CloudFormation stack ARN in the format arn:[partition]:cloudformation:[region]:[account ID]:stack/[stack name]/[resource ID]."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en."
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_product, accept_language must be one of: en, jp, zh."
  }
}

variable "description" {
  description = "Description of the product."
  type        = string
  default     = null
}

variable "distributor" {
  description = "Distributor (i.e., vendor) of the product."
  type        = string
  default     = null
}

variable "support_description" {
  description = "Support information about the product."
  type        = string
  default     = null
}

variable "support_email" {
  description = "Contact email for product support."
  type        = string
  default     = null

  validation {
    condition     = var.support_email == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.support_email))
    error_message = "resource_aws_servicecatalog_product, support_email must be a valid email address."
  }
}

variable "support_url" {
  description = "Contact URL for product support."
  type        = string
  default     = null

  validation {
    condition     = var.support_url == null || can(regex("^https?://.*", var.support_url))
    error_message = "resource_aws_servicecatalog_product, support_url must be a valid URL starting with http:// or https://."
  }
}

variable "tags" {
  description = "Tags to apply to the product."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration block for operation timeouts."
  type = object({
    create = optional(string, "5m")
    read   = optional(string, "10m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {}
}