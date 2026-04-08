##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name" {
  description = "The name of the connection."
  type        = string
}

variable "agent_id" {
  description = "The ID of the agent to connect to."
  type        = string
}

variable "type" {
  description = "The type of the connection. Valid values are: 'database', 'application, 'custom'."
  type        = string
}

variable "subtype" {
  description = "The subtype of the connection. Valid values depend on the type of the connection. For 'database' type, valid values are: 'mysql', 'postgresql', 'sqlserver', 'oracle', 'mongodb', 'redis', 'redshift'. For 'application' type, valid values are: 'ssh', 'rdp'. For 'custom' type, valid values are: any string."
  type        = string
  nullable    = true
  default     = null
}

variable "secrets" {
  description = "(Map of String, Sensitive) A map of secrets to be used by the connection. The key must have the prefix envvar:KEY_NAME or filesystem:KEY_NAME. These prefixes indicate how the secret will be used on runtime."
  sensitive   = true
  type        = map(string)
  default     = null
}

variable "access_modes" {
  description = "Access modes for the connection. Valid values are 'enabled' or 'disabled'."
  type = object({
    connect  = optional(string, "enabled")
    exec     = optional(string, "enabled")
    runbooks = optional(string, "enabled")
    schema   = optional(string, "enabled")
  })
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the connection."
  type        = map(string)
  default     = {}
}

variable "access_control" {
  description = "A set of access control rules to be applied to the connection."
  type        = set(string)
  default     = []
}