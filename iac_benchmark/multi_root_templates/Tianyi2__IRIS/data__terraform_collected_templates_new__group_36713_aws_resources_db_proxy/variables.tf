variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The identifier for the proxy"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name)) || can(regex("^[a-zA-Z]$", var.name))
    error_message = "resource_aws_db_proxy, name must begin with a letter and must contain only ASCII letters, digits, and hyphens; it can't end with a hyphen or contain two consecutive hyphens."
  }
  validation {
    condition     = !can(regex("--", var.name))
    error_message = "resource_aws_db_proxy, name cannot contain two consecutive hyphens."
  }
}

variable "auth" {
  description = "Configuration block(s) with authorization mechanisms to connect to the associated instances or clusters"
  type = list(object({
    auth_scheme               = optional(string)
    client_password_auth_type = optional(string)
    description               = optional(string)
    iam_auth                  = optional(string)
    secret_arn                = optional(string)
    username                  = optional(string)
  }))
  validation {
    condition     = length(var.auth) > 0
    error_message = "resource_aws_db_proxy, auth is required and must contain at least one configuration block."
  }
  validation {
    condition = alltrue([
      for auth in var.auth : auth.auth_scheme == null || contains(["SECRETS"], auth.auth_scheme)
    ])
    error_message = "resource_aws_db_proxy, auth_scheme must be one of: SECRETS."
  }
  validation {
    condition = alltrue([
      for auth in var.auth : auth.client_password_auth_type == null || contains([
        "MYSQL_CACHING_SHA2_PASSWORD",
        "MYSQL_NATIVE_PASSWORD",
        "POSTGRES_SCRAM_SHA_256",
        "POSTGRES_MD5",
        "SQL_SERVER_AUTHENTICATION"
      ], auth.client_password_auth_type)
    ])
    error_message = "resource_aws_db_proxy, client_password_auth_type must be one of: MYSQL_CACHING_SHA2_PASSWORD, MYSQL_NATIVE_PASSWORD, POSTGRES_SCRAM_SHA_256, POSTGRES_MD5, SQL_SERVER_AUTHENTICATION."
  }
  validation {
    condition = alltrue([
      for auth in var.auth : auth.iam_auth == null || contains(["DISABLED", "REQUIRED"], auth.iam_auth)
    ])
    error_message = "resource_aws_db_proxy, iam_auth must be one of: DISABLED, REQUIRED."
  }
}

variable "debug_logging" {
  description = "Whether the proxy includes detailed information about SQL statements in its logs"
  type        = bool
  default     = null
}

variable "engine_family" {
  description = "The kinds of databases that the proxy can connect to"
  type        = string
  validation {
    condition     = contains(["MYSQL", "POSTGRESQL", "SQLSERVER"], var.engine_family)
    error_message = "resource_aws_db_proxy, engine_family must be one of: MYSQL, POSTGRESQL, SQLSERVER."
  }
}

variable "idle_client_timeout" {
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it"
  type        = number
  default     = null
}

variable "require_tls" {
  description = "A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy"
  type        = bool
  default     = null
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role that the proxy uses to access secrets in AWS Secrets Manager"
  type        = string
  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.*", var.role_arn))
    error_message = "resource_aws_db_proxy, role_arn must be a valid IAM role ARN."
  }
}

variable "vpc_security_group_ids" {
  description = "One or more VPC security group IDs to associate with the new proxy"
  type        = list(string)
  default     = null
  validation {
    condition = var.vpc_security_group_ids == null || alltrue([
      for sg in var.vpc_security_group_ids : can(regex("^sg-[0-9a-f]{8,17}$", sg))
    ])
    error_message = "resource_aws_db_proxy, vpc_security_group_ids must be valid security group IDs."
  }
}

variable "vpc_subnet_ids" {
  description = "One or more VPC subnet IDs to associate with the new proxy"
  type        = list(string)
  validation {
    condition     = length(var.vpc_subnet_ids) > 0
    error_message = "resource_aws_db_proxy, vpc_subnet_ids is required and must contain at least one subnet ID."
  }
  validation {
    condition = alltrue([
      for subnet in var.vpc_subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", subnet))
    ])
    error_message = "resource_aws_db_proxy, vpc_subnet_ids must be valid subnet IDs."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts for create, update and delete operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "60m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "60m"
  }
}