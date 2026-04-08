variable "directory_name" {
  description = "Fully qualified name of the directory"
  type        = string

  validation {
    condition     = length(var.directory_name) > 0
    error_message = "resource_aws_appstream_directory_config, directory_name must not be empty."
  }
}

variable "organizational_unit_distinguished_names" {
  description = "Distinguished names of the organizational units for computer accounts"
  type        = list(string)

  validation {
    condition     = length(var.organizational_unit_distinguished_names) > 0
    error_message = "resource_aws_appstream_directory_config, organizational_unit_distinguished_names must contain at least one distinguished name."
  }

  validation {
    condition     = alltrue([for dn in var.organizational_unit_distinguished_names : length(dn) > 0])
    error_message = "resource_aws_appstream_directory_config, organizational_unit_distinguished_names cannot contain empty strings."
  }
}

variable "service_account_credentials" {
  description = "Configuration block for the name of the directory and organizational unit (OU) to use to join the directory config to a Microsoft Active Directory domain"
  type = object({
    account_name     = string
    account_password = string
  })

  validation {
    condition     = var.service_account_credentials != null
    error_message = "resource_aws_appstream_directory_config, service_account_credentials is required."
  }

  validation {
    condition     = var.service_account_credentials == null || length(var.service_account_credentials.account_name) > 0
    error_message = "resource_aws_appstream_directory_config, service_account_credentials account_name must not be empty."
  }

  validation {
    condition     = var.service_account_credentials == null || length(var.service_account_credentials.account_password) > 0
    error_message = "resource_aws_appstream_directory_config, service_account_credentials account_password must not be empty."
  }
}