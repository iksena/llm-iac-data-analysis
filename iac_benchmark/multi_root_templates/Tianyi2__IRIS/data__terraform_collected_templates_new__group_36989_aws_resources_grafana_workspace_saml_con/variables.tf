variable "editor_role_values" {
  description = "The editor role values"
  type        = list(string)

  validation {
    condition     = length(var.editor_role_values) > 0
    error_message = "resource_aws_grafana_workspace_saml_configuration, editor_role_values must contain at least one value."
  }
}

variable "workspace_id" {
  description = "The workspace id"
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "resource_aws_grafana_workspace_saml_configuration, workspace_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "admin_role_values" {
  description = "The admin role values"
  type        = list(string)
  default     = null
}

variable "allowed_organizations" {
  description = "The allowed organizations"
  type        = list(string)
  default     = null
}

variable "email_assertion" {
  description = "The email assertion"
  type        = string
  default     = null
}

variable "groups_assertion" {
  description = "The groups assertion"
  type        = string
  default     = null
}

variable "idp_metadata_url" {
  description = "The IDP Metadata URL"
  type        = string
  default     = null

  validation {
    condition     = var.idp_metadata_url == null || var.idp_metadata_xml == null
    error_message = "resource_aws_grafana_workspace_saml_configuration, idp_metadata_url and idp_metadata_xml cannot both be specified - use only one."
  }
}

variable "idp_metadata_xml" {
  description = "The IDP Metadata XML"
  type        = string
  default     = null
}

variable "login_assertion" {
  description = "The login assertion"
  type        = string
  default     = null
}

variable "login_validity_duration" {
  description = "The login validity duration"
  type        = number
  default     = null
}

variable "name_assertion" {
  description = "The name assertion"
  type        = string
  default     = null
}

variable "org_assertion" {
  description = "The org assertion"
  type        = string
  default     = null
}

variable "role_assertion" {
  description = "The role assertion"
  type        = string
  default     = null
}