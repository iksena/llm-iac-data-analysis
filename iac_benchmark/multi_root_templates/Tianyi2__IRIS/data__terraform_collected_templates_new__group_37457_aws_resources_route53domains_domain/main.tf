resource "aws_route53domains_domain" "this" {
  domain_name        = var.domain_name
  auto_renew         = var.auto_renew
  admin_privacy      = var.admin_privacy
  billing_privacy    = var.billing_privacy
  duration_in_years  = var.duration_in_years
  registrant_privacy = var.registrant_privacy
  tech_privacy       = var.tech_privacy
  transfer_lock      = var.transfer_lock
  tags               = var.tags

  admin_contact {
    address_line_1    = var.admin_contact.address_line_1
    address_line_2    = var.admin_contact.address_line_2
    city              = var.admin_contact.city
    contact_type      = var.admin_contact.contact_type
    country_code      = var.admin_contact.country_code
    email             = var.admin_contact.email
    fax               = var.admin_contact.fax
    first_name        = var.admin_contact.first_name
    last_name         = var.admin_contact.last_name
    organization_name = var.admin_contact.organization_name
    phone_number      = var.admin_contact.phone_number
    state             = var.admin_contact.state
    zip_code          = var.admin_contact.zip_code

    dynamic "extra_param" {
      for_each = var.admin_contact.extra_param != null ? var.admin_contact.extra_param : []
      content {
        name  = extra_param.value.name
        value = extra_param.value.value
      }
    }
  }

  dynamic "billing_contact" {
    for_each = var.billing_contact != null ? [var.billing_contact] : []
    content {
      address_line_1    = billing_contact.value.address_line_1
      address_line_2    = billing_contact.value.address_line_2
      city              = billing_contact.value.city
      contact_type      = billing_contact.value.contact_type
      country_code      = billing_contact.value.country_code
      email             = billing_contact.value.email
      fax               = billing_contact.value.fax
      first_name        = billing_contact.value.first_name
      last_name         = billing_contact.value.last_name
      organization_name = billing_contact.value.organization_name
      phone_number      = billing_contact.value.phone_number
      state             = billing_contact.value.state
      zip_code          = billing_contact.value.zip_code

      dynamic "extra_param" {
        for_each = billing_contact.value.extra_param != null ? billing_contact.value.extra_param : []
        content {
          name  = extra_param.value.name
          value = extra_param.value.value
        }
      }
    }
  }

  dynamic "name_server" {
    for_each = var.name_server != null ? var.name_server : []
    content {
      name     = name_server.value.name
      glue_ips = name_server.value.glue_ips
    }
  }

  registrant_contact {
    address_line_1    = var.registrant_contact.address_line_1
    address_line_2    = var.registrant_contact.address_line_2
    city              = var.registrant_contact.city
    contact_type      = var.registrant_contact.contact_type
    country_code      = var.registrant_contact.country_code
    email             = var.registrant_contact.email
    fax               = var.registrant_contact.fax
    first_name        = var.registrant_contact.first_name
    last_name         = var.registrant_contact.last_name
    organization_name = var.registrant_contact.organization_name
    phone_number      = var.registrant_contact.phone_number
    state             = var.registrant_contact.state
    zip_code          = var.registrant_contact.zip_code

    dynamic "extra_param" {
      for_each = var.registrant_contact.extra_param != null ? var.registrant_contact.extra_param : []
      content {
        name  = extra_param.value.name
        value = extra_param.value.value
      }
    }
  }

  tech_contact {
    address_line_1    = var.tech_contact.address_line_1
    address_line_2    = var.tech_contact.address_line_2
    city              = var.tech_contact.city
    contact_type      = var.tech_contact.contact_type
    country_code      = var.tech_contact.country_code
    email             = var.tech_contact.email
    fax               = var.tech_contact.fax
    first_name        = var.tech_contact.first_name
    last_name         = var.tech_contact.last_name
    organization_name = var.tech_contact.organization_name
    phone_number      = var.tech_contact.phone_number
    state             = var.tech_contact.state
    zip_code          = var.tech_contact.zip_code

    dynamic "extra_param" {
      for_each = var.tech_contact.extra_param != null ? var.tech_contact.extra_param : []
      content {
        name  = extra_param.value.name
        value = extra_param.value.value
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}