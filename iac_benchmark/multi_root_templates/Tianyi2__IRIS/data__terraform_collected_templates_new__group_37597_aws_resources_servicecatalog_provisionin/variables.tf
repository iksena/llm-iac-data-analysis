variable "product_id" {
  description = "Identifier of the product"
  type        = string
}

variable "template_physical_id" {
  description = "Template source as the physical ID of the resource that contains the template. Currently only supports CloudFormation stack ARN"
  type        = string
  default     = null

  validation {
    condition     = var.template_physical_id == null || can(regex("^arn:[^:]*:cloudformation:[^:]*:[^:]*:stack/[^/]*/.*$", var.template_physical_id))
    error_message = "resource_aws_servicecatalog_provisioning_artifact, template_physical_id must be a valid CloudFormation stack ARN in format arn:[partition]:cloudformation:[region]:[account ID]:stack/[stack name]/[resource ID]."
  }
}

variable "template_url" {
  description = "Template source as URL of the CloudFormation template in Amazon S3"
  type        = string
  default     = null

  validation {
    condition     = var.template_url == null || can(regex("^https://", var.template_url))
    error_message = "resource_aws_servicecatalog_provisioning_artifact, template_url must be a valid HTTPS URL."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code"
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_provisioning_artifact, accept_language must be one of: en, jp, zh."
  }
}

variable "active" {
  description = "Whether the product version is active"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the provisioning artifact"
  type        = string
  default     = null
}

variable "disable_template_validation" {
  description = "Whether AWS Service Catalog stops validating the specified provisioning artifact template even if it is invalid"
  type        = bool
  default     = null
}

variable "guidance" {
  description = "Information set by the administrator to provide guidance to end users about which provisioning artifacts to use"
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "DEPRECATED"], var.guidance)
    error_message = "resource_aws_servicecatalog_provisioning_artifact, guidance must be either DEFAULT or DEPRECATED."
  }
}

variable "name" {
  description = "Name of the provisioning artifact"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || !can(regex(" ", var.name))
    error_message = "resource_aws_servicecatalog_provisioning_artifact, name cannot contain spaces."
  }
}

variable "type" {
  description = "Type of provisioning artifact"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    update = optional(string, "3m")
    delete = optional(string, "3m")
  })
  default = {}
}