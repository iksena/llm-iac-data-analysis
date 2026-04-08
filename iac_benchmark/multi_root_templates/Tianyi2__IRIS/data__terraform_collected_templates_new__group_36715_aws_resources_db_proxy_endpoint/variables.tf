variable "db_proxy_endpoint_name" {
  description = "The identifier for the proxy endpoint. An identifier must begin with a letter and must contain only ASCII letters, digits, and hyphens; it can't end with a hyphen or contain two consecutive hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.db_proxy_endpoint_name)) && !can(regex("--", var.db_proxy_endpoint_name))
    error_message = "resource_aws_db_proxy_endpoint, db_proxy_endpoint_name must begin with a letter, contain only ASCII letters, digits, and hyphens, can't end with a hyphen or contain two consecutive hyphens."
  }
}

variable "db_proxy_name" {
  description = "The name of the DB proxy associated with the DB proxy endpoint that you create."
  type        = string
}

variable "vpc_subnet_ids" {
  description = "One or more VPC subnet IDs to associate with the new proxy."
  type        = list(string)

  validation {
    condition     = length(var.vpc_subnet_ids) > 0
    error_message = "resource_aws_db_proxy_endpoint, vpc_subnet_ids must contain at least one subnet ID."
  }
}

variable "vpc_security_group_ids" {
  description = "One or more VPC security group IDs to associate with the new proxy."
  type        = list(string)
  default     = null
}

variable "target_role" {
  description = "Indicates whether the DB proxy endpoint can be used for read/write or read-only operations. The default is READ_WRITE."
  type        = string
  default     = "READ_WRITE"

  validation {
    condition     = contains(["READ_WRITE", "READ_ONLY"], var.target_role)
    error_message = "resource_aws_db_proxy_endpoint, target_role must be either READ_WRITE or READ_ONLY."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
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