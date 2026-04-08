variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) An identifier for the QuickSight data source. This ID is a unique identifier for each AWS Region in an AWS account."
  type        = string
  nullable    = false
}

variable "display_name" {
  description = "(Optional) The display name for the QuickSight data source, maximum of 128 characters."
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = length(var.display_name) <= 128
    error_message = "Data source name must be 128 characters or less."
  }
}

variable "type" {
  description = "(Required) The type of the QuickSight data source. Valid values are `AURORA_POSTGRESQL`, `AURORA`, `ATHENA`, `MYSQL`, `ORACLE`, `POSTGRESQL`, `S3`, `SQLSERVER`, `MARIADB`."
  type        = string
  nullable    = false

  validation {
    condition = contains([
      "AURORA_POSTGRESQL",
      "AURORA",
      "ATHENA",
      "MYSQL",
      "ORACLE",
      "POSTGRESQL",
      "S3",
      "SQLSERVER",
      "MARIADB"
    ], var.type)
    error_message = "Valid values for `type` are `AURORA_POSTGRESQL`, `AURORA`, `ATHENA`, `MYSQL`, `ORACLE`, `POSTGRESQL`, `S3`, `SQLSERVER`, `MARIADB`."
  }
}

variable "parameters" {
  description = <<EOF
  (Required) A configuration for parameters used to connect to the data source. The structure varies based on the data source type:

  **AURORA_POSTGRESQL/AURORA/MYSQL/ORACLE/POSTGRESQL/SQLSERVER/MARIADB:**
    (Required) `database` - The name of the database to connect to.
    (Required) `host` - The hostname of the database server.
    (Optional) `port` - The port number for the database server. Defaults vary by type.

  **ATHENA:**
    (Optional) `workgroup` - The name of the Athena workgroup. Defaults to `primary`.

  **S3:**
    (Required) `manifest_file_location` - The Amazon S3 location of the manifest file in the format `s3://bucket/key`.
    (Optional) `iam_role` - The IAM role ARN that QuickSight uses to access the S3 bucket instead of an account-wide IAM role. Recommended for security best practices.
  EOF
  type        = any
  nullable    = false

  validation {
    condition     = var.parameters != null
    error_message = "Parameters must be a non-null object."
  }
  validation {
    condition = (
      !can(var.parameters.port) ||
      (can(var.parameters.port) && var.parameters.port >= 1 && var.parameters.port <= 65535)
    )
    error_message = "Port parameter must be between `1` and `65535` if specified."
  }
  validation {
    condition = (
      !can(var.parameters.manifest_file_location) ||
      (can(var.parameters.manifest_file_location) && startswith(var.parameters.manifest_file_location, "s3://"))
    )
    error_message = "Value for `manifest_file_location` parameter must start with 's3://' if specified."
  }
  validation {
    condition = (
      !can(var.parameters.iam_role) ||
      (can(provider::aws::arn_parse(var.parameters.iam_role)) && provider::aws::arn_parse(var.parameters.iam_role).service == "iam")
    )
    error_message = "Value for `iam_role` parameter must be a valid IAM role ARN if specified."
  }
}

variable "credentials" {
  description = <<EOF
  (Optional) A configuration for credentials which Amazon QuickSight uses to connect to the data source. Not required for S3 data sources. `credentials` as defined below.
    (Optional) `type` - The type of credentials to use. Valid values are `CREDENTIAL_PAIR`, `COPY_DATA_SOURCE`, or `SECRETS_MANAGER`. Defaults to `SECRETS_MANAGER`.
    (Optional) `credential_pair` - Credential pair with `username` and `password`.
    (Optional) `data_source` - The ARN of a data source that has the credential pair to use.
    (Optional) `secrets_manager_secret` - The ARN of the secret in AWS Secrets Manager containing the credentials.
  EOF
  type = object({
    type = optional(string, "SECRETS_MANAGER")
    credential_pair = optional(object({
      username = string
      password = string
    }))
    data_source            = optional(string)
    secrets_manager_secret = optional(string)
  })
  default   = null
  nullable  = true
  sensitive = true

  validation {
    condition = anytrue([
      var.credentials == null,
      var.credentials.type != "CREDENTIAL_PAIR",
      var.credentials.type == "CREDENTIAL_PAIR" && var.credentials.credential_pair != null,
    ])
    error_message = "If `type` is set to `CREDENTIAL_PAIR`, then `credential_pair` must be provided."
  }
  validation {
    condition = anytrue([
      var.credentials == null,
      var.credentials.type != "COPY_DATA_SOURCE",
      var.credentials.type == "COPY_DATA_SOURCE" && var.credentials.data_source != null,
    ])
    error_message = "If `type` is set to `COPY_DATA_SOURCE`, then `data_source` must be provided."
  }
  validation {
    condition = anytrue([
      var.credentials == null,
      var.credentials.type != "SECRETS_MANAGER",
      var.credentials.type == "SECRETS_MANAGER" && var.credentials.secrets_manager_secret != null,
    ])
    error_message = "If `type` is set to `SECRETS_MANAGER`, then `secrets_manager_secret` must be provided."
  }
}

variable "permissions" {
  description = <<EOF
  (Optional) A list of resource permissions on the data source. Maximum of 64 items. Each item of `permissions` as defined below.
    (Required) `principal` - The Amazon Resource Name (ARN) of the principal. This can be one of the following:
      - The ARN of an Amazon QuickSight user or group associated with a data source or dataset. (This is common.)
      - The ARN of an Amazon QuickSight user, group, or namespace associated with an analysis, dashboard, template, or theme. (This is common.)
      - The ARN of an Amazon Web Services account root: This is an IAM ARN rather than a QuickSight ARN. Use this option only to share resources (templates) across Amazon Web Services accounts. (This is less common.)
    (Optional) `role` - A role of principal with a pre-defined set of permissions. Valid values are `OWNER` and `USER`. Conflicting with `actions`.
    (Optional) `actions` - A set of IAM actions to grant or revoke permissions on. Maximum of 16 items. Conflicting with `role`.
  EOF
  type = list(object({
    principal = string
    role      = optional(string)
    actions   = optional(set(string), [])
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.permissions) <= 64
    error_message = "Maximum of 64 permissions can be specified."
  }
  validation {
    condition = alltrue([
      for permission in var.permissions :
      contains(["OWNER", "USER"], permission.role) || length(permission.actions) > 0
    ])
    error_message = "Valid values for `permission.role` are `OWNER` and `USER`. If `role` is not set, then `actions` must be specified."
  }
  validation {
    condition = alltrue([
      for permission in var.permissions :
      length(permission.actions) <= 16
    ])
    error_message = "Maximum of 16 actions can be specified per permission."
  }
}

variable "vpc_connection" {
  description = <<EOF
  (Optional) A configuration for VPC connection of the data source. `vpc_connection` as defined below.
    (Optional) `enabled` - Whether to use a VPC connection for the data source. Defaults to `false`.
    (Optional) `arn` - The Amazon Resource Name (ARN) for the VPC connection.
  EOF
  type = object({
    enabled = optional(bool, false)
    arn     = optional(string, null)
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.vpc_connection.enabled == false,
      var.vpc_connection.enabled == true && var.vpc_connection.arn != null,
    ])
    error_message = "If VPC connection is enabled, the ARN must be provided."
  }
}

variable "ssl" {
  description = <<EOF
  (Optional) A configuration for SSL (Secure Socket Layer) properties that apply when Amazon QuickSight connects to the data source. `ssl` as defined below.
    (Optional) `enabled` - Whether to use SSL for the connection. Defaults to `true`.
  EOF
  type = object({
    enabled = optional(bool, true)
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
