variable "agent_arns" {
  description = "A list of DataSync Agent ARNs with which this location will be associated"
  type        = list(string)

  validation {
    condition     = length(var.agent_arns) > 0
    error_message = "resource_aws_datasync_location_hdfs, agent_arns must contain at least one ARN."
  }
}

variable "authentication_type" {
  description = "The type of authentication used to determine the identity of the user"
  type        = string

  validation {
    condition     = contains(["SIMPLE", "KERBEROS"], var.authentication_type)
    error_message = "resource_aws_datasync_location_hdfs, authentication_type must be either 'SIMPLE' or 'KERBEROS'."
  }
}

variable "name_node" {
  description = "The NameNode that manages the HDFS namespace"
  type = object({
    hostname = string
    port     = number
  })

  validation {
    condition     = var.name_node.hostname != ""
    error_message = "resource_aws_datasync_location_hdfs, name_node hostname cannot be empty."
  }

  validation {
    condition     = var.name_node.port > 0 && var.name_node.port <= 65535
    error_message = "resource_aws_datasync_location_hdfs, name_node port must be between 1 and 65535."
  }
}

variable "block_size" {
  description = "The size of data blocks to write into the HDFS cluster. Must be a multiple of 512 bytes"
  type        = number
  default     = null

  validation {
    condition     = var.block_size == null || (var.block_size > 0 && var.block_size % 512 == 0)
    error_message = "resource_aws_datasync_location_hdfs, block_size must be a positive number that is a multiple of 512 bytes."
  }
}

variable "kerberos_keytab" {
  description = "The Kerberos key table (keytab) that contains mappings between the defined Kerberos principal and the encrypted keys"
  type        = string
  default     = null
}

variable "kerberos_keytab_base64" {
  description = "Base64-encoded binary data for Kerberos keytab"
  type        = string
  default     = null
}

variable "kerberos_krb5_conf" {
  description = "The krb5.conf file that contains the Kerberos configuration information"
  type        = string
  default     = null
}

variable "kerberos_krb5_conf_base64" {
  description = "Base64-encoded binary data for krb5.conf"
  type        = string
  default     = null
}

variable "kerberos_principal" {
  description = "The Kerberos principal with access to the files and folders on the HDFS cluster"
  type        = string
  default     = null
}

variable "kms_key_provider_uri" {
  description = "The URI of the HDFS cluster's Key Management Server (KMS)"
  type        = string
  default     = null
}

variable "qop_configuration" {
  description = "The Quality of Protection (QOP) configuration specifies the RPC and data transfer protection settings"
  type = object({
    data_transfer_protection = optional(string)
    rpc_protection           = optional(string)
  })
  default = null

  validation {
    condition = var.qop_configuration == null || (
      var.qop_configuration.data_transfer_protection == null ||
      contains(["DISABLED", "AUTHENTICATION", "INTEGRITY", "PRIVACY"], var.qop_configuration.data_transfer_protection)
    )
    error_message = "resource_aws_datasync_location_hdfs, qop_configuration data_transfer_protection must be one of 'DISABLED', 'AUTHENTICATION', 'INTEGRITY', or 'PRIVACY'."
  }

  validation {
    condition = var.qop_configuration == null || (
      var.qop_configuration.rpc_protection == null ||
      contains(["DISABLED", "AUTHENTICATION", "INTEGRITY", "PRIVACY"], var.qop_configuration.rpc_protection)
    )
    error_message = "resource_aws_datasync_location_hdfs, qop_configuration rpc_protection must be one of 'DISABLED', 'AUTHENTICATION', 'INTEGRITY', or 'PRIVACY'."
  }
}

variable "replication_factor" {
  description = "The number of DataNodes to replicate the data to when writing to the HDFS cluster"
  type        = number
  default     = null

  validation {
    condition     = var.replication_factor == null || var.replication_factor > 0
    error_message = "resource_aws_datasync_location_hdfs, replication_factor must be a positive number."
  }
}

variable "simple_user" {
  description = "The user name used to identify the client on the host operating system"
  type        = string
  default     = null
}

variable "subdirectory" {
  description = "A subdirectory in the HDFS cluster. This subdirectory is used to read data from or write data to the HDFS cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location"
  type        = map(string)
  default     = {}
}

# Conditional validations
locals {
  is_kerberos = var.authentication_type == "KERBEROS"
  is_simple   = var.authentication_type == "SIMPLE"

  has_kerberos_keytab    = var.kerberos_keytab != null || var.kerberos_keytab_base64 != null
  has_kerberos_krb5_conf = var.kerberos_krb5_conf != null || var.kerberos_krb5_conf_base64 != null
}

# Custom validations using check blocks
check "kerberos_authentication_requirements" {
  assert {
    condition = !local.is_kerberos || (
      var.kerberos_principal != null &&
      local.has_kerberos_keytab &&
      local.has_kerberos_krb5_conf
    )
    error_message = "resource_aws_datasync_location_hdfs, when authentication_type is 'KERBEROS', kerberos_principal, kerberos_keytab (or kerberos_keytab_base64), and kerberos_krb5_conf (or kerberos_krb5_conf_base64) are required."
  }
}

check "simple_authentication_requirements" {
  assert {
    condition     = !local.is_simple || var.simple_user != null
    error_message = "resource_aws_datasync_location_hdfs, when authentication_type is 'SIMPLE', simple_user is required."
  }
}

check "mutually_exclusive_kerberos_keytab" {
  assert {
    condition     = !(var.kerberos_keytab != null && var.kerberos_keytab_base64 != null)
    error_message = "resource_aws_datasync_location_hdfs, kerberos_keytab and kerberos_keytab_base64 are mutually exclusive."
  }
}

check "mutually_exclusive_kerberos_krb5_conf" {
  assert {
    condition     = !(var.kerberos_krb5_conf != null && var.kerberos_krb5_conf_base64 != null)
    error_message = "resource_aws_datasync_location_hdfs, kerberos_krb5_conf and kerberos_krb5_conf_base64 are mutually exclusive."
  }
}