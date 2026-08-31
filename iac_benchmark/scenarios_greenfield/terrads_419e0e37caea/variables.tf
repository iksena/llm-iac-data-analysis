##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# Establish this is a HUB or spoke configuration
variable "is_hub" {
  type    = bool
  default = false
}

variable "spoke_def" {
  type    = string
  default = "001"
}

variable "org" {
  type = object({
    organization_name = string
    organization_unit = string
    environment_type  = string
    environment_name  = string
  })
  default     = {
    organization_name = "benchmark-org"
    organization_unit  = "benchmark-ou"
    environment_type   = "dev"
    environment_name   = "benchmark"
  }
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

variable "zones" {
  type    = any
  default = {}
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "dns_vpc" {
  type = object({
    vpc_id     = string
    vpc_region = optional(string, "us-east-1")
  })
  default = {
    vpc_id     = ""
    vpc_region = ""
  }
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "ram" {
  type = object({
    enabled                   = optional(bool, true)
    allow_external_principals = optional(bool, false)
    principals                = optional(list(string), [])
  })
  default = {
    enabled                   = false
    allow_external_principals = false
    principals                = []
  }
}

variable "enable_auto_accept" {
  type    = bool
  default = true
}

variable "shared" {
  type = object({
    ram_shares     = any
    resolver_rules = any
  })
  default = {
    ram_shares     = {}
    resolver_rules = {}
  }
}

variable "association_zone_ids" {
  type    = set(string)
  default = []
}

variable "custom_resolver_rules" {
  description = "Custom resolver rules to create"
  type        = any
  default     = {}
}