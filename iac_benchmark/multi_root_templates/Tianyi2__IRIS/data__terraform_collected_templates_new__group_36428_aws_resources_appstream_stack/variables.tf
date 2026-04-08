variable "name" {
  description = "Unique name for the AppStream stack"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the AppStream stack"
  type        = string
  default     = null
}

variable "display_name" {
  description = "Stack name to display"
  type        = string
  default     = null
}

variable "embed_host_domains" {
  description = "Domains where AppStream 2.0 streaming sessions can be embedded in an iframe"
  type        = list(string)
  default     = null
}

variable "feedback_url" {
  description = "URL that users are redirected to after they click the Send Feedback link"
  type        = string
  default     = null
}

variable "redirect_url" {
  description = "URL that users are redirected to after their streaming session ends"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "access_endpoints" {
  description = "Set of configuration blocks defining the interface VPC endpoints"
  type = list(object({
    endpoint_type = string
    vpce_id       = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for endpoint in var.access_endpoints :
      contains(["STREAMING"], endpoint.endpoint_type)
    ])
    error_message = "resource_aws_appstream_stack, access_endpoints: endpoint_type must be 'STREAMING'."
  }
}

variable "application_settings" {
  description = "Settings for application settings persistence"
  type = object({
    enabled        = bool
    settings_group = optional(string)
  })
  default = null

  validation {
    condition = var.application_settings == null || (
      var.application_settings.enabled == false ||
      (var.application_settings.enabled == true && var.application_settings.settings_group != null)
    )
    error_message = "resource_aws_appstream_stack, application_settings: settings_group is required when enabled is true."
  }

  validation {
    condition = var.application_settings == null || (
      var.application_settings.settings_group == null ||
      length(var.application_settings.settings_group) <= 100
    )
    error_message = "resource_aws_appstream_stack, application_settings: settings_group can be up to 100 characters."
  }
}

variable "storage_connectors" {
  description = "Configuration block for the storage connectors to enable"
  type = list(object({
    connector_type      = string
    domains             = optional(list(string))
    resource_identifier = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for connector in var.storage_connectors :
      contains(["HOMEFOLDERS", "GOOGLE_DRIVE", "ONE_DRIVE"], connector.connector_type)
    ])
    error_message = "resource_aws_appstream_stack, storage_connectors: connector_type must be one of 'HOMEFOLDERS', 'GOOGLE_DRIVE', or 'ONE_DRIVE'."
  }
}

variable "user_settings" {
  description = "Configuration block for the actions that are enabled or disabled for users during their streaming sessions"
  type = list(object({
    action     = string
    permission = string
  }))
  default = []

  validation {
    condition = alltrue([
      for setting in var.user_settings :
      contains([
        "AUTO_TIME_ZONE_REDIRECTION",
        "CLIPBOARD_COPY_FROM_LOCAL_DEVICE",
        "CLIPBOARD_COPY_TO_LOCAL_DEVICE",
        "DOMAIN_PASSWORD_SIGNIN",
        "DOMAIN_SMART_CARD_SIGNIN",
        "FILE_UPLOAD",
        "FILE_DOWNLOAD",
        "PRINTING_TO_LOCAL_DEVICE"
      ], setting.action)
    ])
    error_message = "resource_aws_appstream_stack, user_settings: action must be one of 'AUTO_TIME_ZONE_REDIRECTION', 'CLIPBOARD_COPY_FROM_LOCAL_DEVICE', 'CLIPBOARD_COPY_TO_LOCAL_DEVICE', 'DOMAIN_PASSWORD_SIGNIN', 'DOMAIN_SMART_CARD_SIGNIN', 'FILE_UPLOAD', 'FILE_DOWNLOAD', or 'PRINTING_TO_LOCAL_DEVICE'."
  }

  validation {
    condition = alltrue([
      for setting in var.user_settings :
      contains(["ENABLED", "DISABLED"], setting.permission)
    ])
    error_message = "resource_aws_appstream_stack, user_settings: permission must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "streaming_experience_settings" {
  description = "The streaming protocol you want your stack to prefer"
  type = object({
    preferred_protocol = optional(string)
  })
  default = null

  validation {
    condition = var.streaming_experience_settings == null || (
      var.streaming_experience_settings.preferred_protocol == null ||
      contains(["TCP", "UDP"], var.streaming_experience_settings.preferred_protocol)
    )
    error_message = "resource_aws_appstream_stack, streaming_experience_settings: preferred_protocol must be either 'TCP' or 'UDP'."
  }
}