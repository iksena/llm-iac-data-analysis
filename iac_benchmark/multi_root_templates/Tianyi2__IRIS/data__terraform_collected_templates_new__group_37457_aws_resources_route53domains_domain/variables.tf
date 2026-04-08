variable "admin_contact" {
  description = "Details about the domain administrative contact"
  type = object({
    address_line_1 = optional(string)
    address_line_2 = optional(string)
    city           = optional(string)
    contact_type   = optional(string)
    country_code   = optional(string)
    email          = optional(string)
    extra_param = optional(list(object({
      name  = string
      value = string
    })))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })

  validation {
    condition     = var.admin_contact != null
    error_message = "resource_aws_route53domains_domain, admin_contact is required."
  }
}

variable "admin_privacy" {
  description = "Whether domain administrative contact information is concealed from WHOIS queries"
  type        = bool
  default     = true
}

variable "auto_renew" {
  description = "Whether the domain registration is set to renew automatically"
  type        = bool
  default     = true
}

variable "billing_contact" {
  description = "Details about the domain billing contact"
  type = object({
    address_line_1 = optional(string)
    address_line_2 = optional(string)
    city           = optional(string)
    contact_type   = optional(string)
    country_code   = optional(string)
    email          = optional(string)
    extra_param = optional(list(object({
      name  = string
      value = string
    })))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })
  default = null
}

variable "billing_privacy" {
  description = "Whether domain billing contact information is concealed from WHOIS queries"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The name of the domain"
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_route53domains_domain, domain_name must not be empty."
  }
}

variable "duration_in_years" {
  description = "The number of years that you want to register the domain for. Domains are registered for a minimum of one year"
  type        = number
  default     = null

  validation {
    condition     = var.duration_in_years == null || var.duration_in_years >= 1
    error_message = "resource_aws_route53domains_domain, duration_in_years must be at least 1 year."
  }
}

variable "name_server" {
  description = "The list of nameservers for the domain"
  type = list(object({
    glue_ips = optional(list(string))
    name     = string
  }))
  default = null

  validation {
    condition = var.name_server == null || alltrue([
      for ns in var.name_server : length(ns.name) > 0
    ])
    error_message = "resource_aws_route53domains_domain, name_server name must not be empty."
  }
}

variable "registrant_contact" {
  description = "Details about the domain registrant"
  type = object({
    address_line_1 = optional(string)
    address_line_2 = optional(string)
    city           = optional(string)
    contact_type   = optional(string)
    country_code   = optional(string)
    email          = optional(string)
    extra_param = optional(list(object({
      name  = string
      value = string
    })))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })

  validation {
    condition     = var.registrant_contact != null
    error_message = "resource_aws_route53domains_domain, registrant_contact is required."
  }
}

variable "registrant_privacy" {
  description = "Whether domain registrant contact information is concealed from WHOIS queries"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tech_contact" {
  description = "Details about the domain technical contact"
  type = object({
    address_line_1 = optional(string)
    address_line_2 = optional(string)
    city           = optional(string)
    contact_type   = optional(string)
    country_code   = optional(string)
    email          = optional(string)
    extra_param = optional(list(object({
      name  = string
      value = string
    })))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })

  validation {
    condition     = var.tech_contact != null
    error_message = "resource_aws_route53domains_domain, tech_contact is required."
  }
}

variable "tech_privacy" {
  description = "Whether domain technical contact information is concealed from WHOIS queries"
  type        = bool
  default     = true
}

variable "transfer_lock" {
  description = "Whether the domain is locked for transfer"
  type        = bool
  default     = true
}