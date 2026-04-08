variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "file_system_id" {
  description = "The ID of the Amazon FSx ONTAP File System that this SVM will be created on."
  type        = string
  validation {
    condition     = can(regex("^fs-[0-9a-fA-F]{17}$", var.file_system_id))
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, file_system_id must be a valid FSx file system ID (format: fs- followed by 17 hexadecimal characters)."
  }
}

variable "name" {
  description = "The name of the SVM. You can use a maximum of 47 alphanumeric characters, plus the underscore (_) special character."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,47}$", var.name))
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, name must contain only alphanumeric characters and underscores, and be 1-47 characters long."
  }
}

variable "root_volume_security_style" {
  description = "Specifies the root volume security style. Valid values are UNIX, NTFS, and MIXED. All volumes created under this SVM will inherit the root security style unless the security style is specified on the volume. Default value is UNIX."
  type        = string
  default     = "UNIX"
  validation {
    condition     = contains(["UNIX", "NTFS", "MIXED"], var.root_volume_security_style)
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, root_volume_security_style must be one of: UNIX, NTFS, or MIXED."
  }
}

variable "svm_admin_password" {
  description = "Specifies the password to use when logging on to the SVM using a secure shell (SSH) connection to the SVM's management endpoint. Doing so enables you to manage the SVM using the NetApp ONTAP CLI or REST API. If you do not specify a password, you can still use the file system's fsxadmin user to manage the SVM."
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = var.svm_admin_password == null || length(var.svm_admin_password) >= 8
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, svm_admin_password must be at least 8 characters long if specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the storage virtual machine. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "active_directory_configuration" {
  description = "Configuration block that Amazon FSx uses to join the FSx ONTAP Storage Virtual Machine(SVM) to your Microsoft Active Directory (AD) directory."
  type = object({
    netbios_name = string
    self_managed_active_directory_configuration = optional(object({
      dns_ips                                = list(string)
      domain_name                            = string
      password                               = string
      username                               = string
      file_system_administrators_group       = optional(string)
      organizational_unit_distinguished_name = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.active_directory_configuration == null || (
      var.active_directory_configuration.netbios_name != null &&
      length(var.active_directory_configuration.netbios_name) <= 15 &&
      can(regex("^[a-zA-Z0-9-]{1,15}$", var.active_directory_configuration.netbios_name))
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, netbios_name must be 1-15 characters long and contain only alphanumeric characters and hyphens."
  }

  validation {
    condition = var.active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration == null || (
      var.active_directory_configuration.self_managed_active_directory_configuration.dns_ips != null &&
      length(var.active_directory_configuration.self_managed_active_directory_configuration.dns_ips) >= 1 &&
      length(var.active_directory_configuration.self_managed_active_directory_configuration.dns_ips) <= 3 &&
      alltrue([for ip in var.active_directory_configuration.self_managed_active_directory_configuration.dns_ips : can(cidrhost("${ip}/32", 0))])
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, dns_ips must be a list of 1-3 valid IP addresses."
  }

  validation {
    condition = var.active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration == null || (
      var.active_directory_configuration.self_managed_active_directory_configuration.domain_name != null &&
      can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.active_directory_configuration.self_managed_active_directory_configuration.domain_name))
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, domain_name must be a valid fully qualified domain name."
  }

  validation {
    condition = var.active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration == null || (
      var.active_directory_configuration.self_managed_active_directory_configuration.password != null &&
      length(var.active_directory_configuration.self_managed_active_directory_configuration.password) >= 1
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, password must be specified for self-managed Active Directory configuration."
  }

  validation {
    condition = var.active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration == null || (
      var.active_directory_configuration.self_managed_active_directory_configuration.username != null &&
      length(var.active_directory_configuration.self_managed_active_directory_configuration.username) >= 1
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, username must be specified for self-managed Active Directory configuration."
  }

  validation {
    condition = var.active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration == null || var.active_directory_configuration.self_managed_active_directory_configuration.organizational_unit_distinguished_name == null || (
      can(regex("^OU=", var.active_directory_configuration.self_managed_active_directory_configuration.organizational_unit_distinguished_name))
    )
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, organizational_unit_distinguished_name must start with 'OU=' when specified."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
    update = "30m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update))
    ])
    error_message = "resource_aws_fsx_ontap_storage_virtual_machine, timeout values must be in the format of number followed by s, m, or h (e.g., 30m, 1h)."
  }
}