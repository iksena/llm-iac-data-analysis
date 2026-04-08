variable "domain_name" {
  description = "The name of the registered domain"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]*[a-zA-Z0-9])?\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "resource_aws_route53domains_registered_domain, domain_name must be a valid domain name format."
  }
}

variable "admin_contact" {
  description = "Details about the domain administrative contact"
  type = object({
    address_line_1    = optional(string)
    address_line_2    = optional(string)
    city              = optional(string)
    contact_type      = optional(string)
    country_code      = optional(string)
    email             = optional(string)
    extra_params      = optional(map(string))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })
  default = null

  validation {
    condition = var.admin_contact == null || (
      var.admin_contact.contact_type == null ||
      contains(["PERSON", "COMPANY", "ASSOCIATION", "PUBLIC_BODY", "RESELLER"], var.admin_contact.contact_type)
    )
    error_message = "resource_aws_route53domains_registered_domain, admin_contact.contact_type must be one of: PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER."
  }

  validation {
    condition = var.admin_contact == null || (
      var.admin_contact.phone_number == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.admin_contact.phone_number))
    )
    error_message = "resource_aws_route53domains_registered_domain, admin_contact.phone_number must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.admin_contact == null || (
      var.admin_contact.fax == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.admin_contact.fax))
    )
    error_message = "resource_aws_route53domains_registered_domain, admin_contact.fax must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.admin_contact == null || (
      var.admin_contact.email == null ||
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.admin_contact.email))
    )
    error_message = "resource_aws_route53domains_registered_domain, admin_contact.email must be a valid email address."
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
    address_line_1    = optional(string)
    address_line_2    = optional(string)
    city              = optional(string)
    contact_type      = optional(string)
    country_code      = optional(string)
    email             = optional(string)
    extra_params      = optional(map(string))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })
  default = null

  validation {
    condition = var.billing_contact == null || (
      var.billing_contact.contact_type == null ||
      contains(["PERSON", "COMPANY", "ASSOCIATION", "PUBLIC_BODY", "RESELLER"], var.billing_contact.contact_type)
    )
    error_message = "resource_aws_route53domains_registered_domain, billing_contact.contact_type must be one of: PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER."
  }

  validation {
    condition = var.billing_contact == null || (
      var.billing_contact.phone_number == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.billing_contact.phone_number))
    )
    error_message = "resource_aws_route53domains_registered_domain, billing_contact.phone_number must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.billing_contact == null || (
      var.billing_contact.fax == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.billing_contact.fax))
    )
    error_message = "resource_aws_route53domains_registered_domain, billing_contact.fax must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.billing_contact == null || (
      var.billing_contact.email == null ||
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.billing_contact.email))
    )
    error_message = "resource_aws_route53domains_registered_domain, billing_contact.email must be a valid email address."
  }
}

variable "billing_privacy" {
  description = "Whether domain billing contact information is concealed from WHOIS queries"
  type        = bool
  default     = true
}

variable "name_server" {
  description = "The list of nameservers for the domain"
  type = list(object({
    name     = string
    glue_ips = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for ns in var.name_server : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]*[a-zA-Z0-9])?\\.[a-zA-Z]{2,}$", ns.name))
    ])
    error_message = "resource_aws_route53domains_registered_domain, name_server.name must be a valid fully qualified host name."
  }

  validation {
    condition = alltrue([
      for ns in var.name_server : ns.glue_ips == null || length(ns.glue_ips) <= 2
    ])
    error_message = "resource_aws_route53domains_registered_domain, name_server.glue_ips can contain only one IPv4 and one IPv6 address (maximum 2 total)."
  }

  validation {
    condition = alltrue([
      for ns in var.name_server : ns.glue_ips == null || alltrue([
        for ip in ns.glue_ips : can(cidrhost("${ip}/32", 0)) || can(cidrhost("${ip}/128", 0))
      ])
    ])
    error_message = "resource_aws_route53domains_registered_domain, name_server.glue_ips must contain valid IPv4 or IPv6 addresses."
  }
}

variable "registrant_contact" {
  description = "Details about the domain registrant"
  type = object({
    address_line_1    = optional(string)
    address_line_2    = optional(string)
    city              = optional(string)
    contact_type      = optional(string)
    country_code      = optional(string)
    email             = optional(string)
    extra_params      = optional(map(string))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })
  default = null

  validation {
    condition = var.registrant_contact == null || (
      var.registrant_contact.contact_type == null ||
      contains(["PERSON", "COMPANY", "ASSOCIATION", "PUBLIC_BODY", "RESELLER"], var.registrant_contact.contact_type)
    )
    error_message = "resource_aws_route53domains_registered_domain, registrant_contact.contact_type must be one of: PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER."
  }

  validation {
    condition = var.registrant_contact == null || (
      var.registrant_contact.phone_number == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.registrant_contact.phone_number))
    )
    error_message = "resource_aws_route53domains_registered_domain, registrant_contact.phone_number must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.registrant_contact == null || (
      var.registrant_contact.fax == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.registrant_contact.fax))
    )
    error_message = "resource_aws_route53domains_registered_domain, registrant_contact.fax must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.registrant_contact == null || (
      var.registrant_contact.email == null ||
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.registrant_contact.email))
    )
    error_message = "resource_aws_route53domains_registered_domain, registrant_contact.email must be a valid email address."
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
    address_line_1    = optional(string)
    address_line_2    = optional(string)
    city              = optional(string)
    contact_type      = optional(string)
    country_code      = optional(string)
    email             = optional(string)
    extra_params      = optional(map(string))
    fax               = optional(string)
    first_name        = optional(string)
    last_name         = optional(string)
    organization_name = optional(string)
    phone_number      = optional(string)
    state             = optional(string)
    zip_code          = optional(string)
  })
  default = null

  validation {
    condition = var.tech_contact == null || (
      var.tech_contact.contact_type == null ||
      contains(["PERSON", "COMPANY", "ASSOCIATION", "PUBLIC_BODY", "RESELLER"], var.tech_contact.contact_type)
    )
    error_message = "resource_aws_route53domains_registered_domain, tech_contact.contact_type must be one of: PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER."
  }

  validation {
    condition = var.tech_contact == null || (
      var.tech_contact.phone_number == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.tech_contact.phone_number))
    )
    error_message = "resource_aws_route53domains_registered_domain, tech_contact.phone_number must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.tech_contact == null || (
      var.tech_contact.fax == null ||
      can(regex("^\\+[1-9]\\d{1,14}\\.[0-9]+$", var.tech_contact.fax))
    )
    error_message = "resource_aws_route53domains_registered_domain, tech_contact.fax must be in format '+[country dialing code].[number including any area code]'."
  }

  validation {
    condition = var.tech_contact == null || (
      var.tech_contact.email == null ||
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.tech_contact.email))
    )
    error_message = "resource_aws_route53domains_registered_domain, tech_contact.email must be a valid email address."
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

variable "timeouts" {
  description = "Timeouts for resource operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create))
    error_message = "resource_aws_route53domains_registered_domain, timeouts.create must be a valid duration format (e.g., '30m', '1h', '300s')."
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.update))
    error_message = "resource_aws_route53domains_registered_domain, timeouts.update must be a valid duration format (e.g., '30m', '1h', '300s')."
  }
}