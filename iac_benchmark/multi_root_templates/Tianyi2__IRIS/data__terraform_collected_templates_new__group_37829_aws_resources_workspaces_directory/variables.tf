variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "directory_id" {
  description = "The directory identifier for registration in WorkSpaces service"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The identifiers of the subnets where the directory resides"
  type        = list(string)
  default     = null
}

variable "ip_group_ids" {
  description = "The identifiers of the IP access control groups associated with the directory"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags assigned to the WorkSpaces directory"
  type        = map(string)
  default     = {}
}

variable "workspace_type" {
  description = "Specifies the type of WorkSpaces directory"
  type        = string
  default     = "PERSONAL"
  validation {
    condition     = contains(["PERSONAL", "POOLS"], var.workspace_type)
    error_message = "resource_aws_workspaces_directory, workspace_type must be either 'PERSONAL' or 'POOLS'."
  }
}

variable "workspace_directory_name" {
  description = "The name of the WorkSpaces directory when workspace_type is set to POOLS"
  type        = string
  default     = null
}

variable "workspace_directory_description" {
  description = "The description of the WorkSpaces directory when workspace_type is set to POOLS"
  type        = string
  default     = null
}

variable "user_identity_type" {
  description = "Specifies the user identity type for the WorkSpaces directory"
  type        = string
  default     = null
  validation {
    condition     = var.user_identity_type == null || contains(["CUSTOMER_MANAGED", "AWS_DIRECTORY_SERVICE", "AWS_IAM_IDENTITY_CENTER"], var.user_identity_type)
    error_message = "resource_aws_workspaces_directory, user_identity_type must be one of 'CUSTOMER_MANAGED', 'AWS_DIRECTORY_SERVICE', or 'AWS_IAM_IDENTITY_CENTER'."
  }
}

variable "certificate_based_auth_properties" {
  description = "Configuration of certificate-based authentication (CBA) integration"
  type = object({
    certificate_authority_arn = optional(string)
    status                    = optional(string, "DISABLED")
  })
  default = null
  validation {
    condition     = var.certificate_based_auth_properties == null || contains(["ENABLED", "DISABLED"], var.certificate_based_auth_properties.status)
    error_message = "resource_aws_workspaces_directory, certificate_based_auth_properties.status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "saml_properties" {
  description = "Configuration of SAML authentication integration"
  type = object({
    relay_state_parameter_name = optional(string, "RelayState")
    status                     = optional(string, "DISABLED")
    user_access_url            = optional(string)
  })
  default = null
  validation {
    condition     = var.saml_properties == null || contains(["ENABLED", "DISABLED"], var.saml_properties.status)
    error_message = "resource_aws_workspaces_directory, saml_properties.status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "self_service_permissions" {
  description = "Permissions to enable or disable self-service capabilities when workspace_type is set to PERSONAL"
  type = object({
    change_compute_type  = optional(bool, false)
    increase_volume_size = optional(bool, false)
    rebuild_workspace    = optional(bool, false)
    restart_workspace    = optional(bool, true)
    switch_running_mode  = optional(bool, false)
  })
  default = null
}

variable "workspace_access_properties" {
  description = "Specifies which devices and operating systems users can use to access their WorkSpaces"
  type = object({
    device_type_android    = optional(string)
    device_type_chromeos   = optional(string)
    device_type_ios        = optional(string)
    device_type_linux      = optional(string)
    device_type_osx        = optional(string)
    device_type_web        = optional(string)
    device_type_windows    = optional(string)
    device_type_zeroclient = optional(string)
  })
  default = null
  validation {
    condition = var.workspace_access_properties == null || alltrue([
      var.workspace_access_properties.device_type_android == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_android),
      var.workspace_access_properties.device_type_chromeos == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_chromeos),
      var.workspace_access_properties.device_type_ios == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_ios),
      var.workspace_access_properties.device_type_linux == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_linux),
      var.workspace_access_properties.device_type_osx == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_osx),
      var.workspace_access_properties.device_type_web == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_web),
      var.workspace_access_properties.device_type_windows == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_windows),
      var.workspace_access_properties.device_type_zeroclient == null || contains(["ALLOW", "DENY"], var.workspace_access_properties.device_type_zeroclient)
    ])
    error_message = "resource_aws_workspaces_directory, workspace_access_properties device type values must be either 'ALLOW' or 'DENY'."
  }
}

variable "workspace_creation_properties" {
  description = "Default properties that are used for creating WorkSpaces"
  type = object({
    custom_security_group_id            = optional(string)
    default_ou                          = optional(string)
    enable_internet_access              = optional(bool)
    enable_maintenance_mode             = optional(bool)
    user_enabled_as_local_administrator = optional(bool)
  })
  default = null
  validation {
    condition     = var.workspace_creation_properties == null || var.workspace_creation_properties.default_ou == null || can(regex("^OU=.+,DC=.+(,DC=.+)*$", var.workspace_creation_properties.default_ou))
    error_message = "resource_aws_workspaces_directory, workspace_creation_properties.default_ou must conform to pattern 'OU=<value>,DC=<value>,...,DC=<value>'."
  }
}

variable "active_directory_config" {
  description = "Configuration for Active Directory integration when workspace_type is set to POOLS"
  type = object({
    domain_name                = string
    service_account_secret_arn = string
  })
  default = null
}