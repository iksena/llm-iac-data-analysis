resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain_name

  admin_privacy      = var.admin_privacy
  auto_renew         = var.auto_renew
  billing_privacy    = var.billing_privacy
  registrant_privacy = var.registrant_privacy
  tech_privacy       = var.tech_privacy
  transfer_lock      = var.transfer_lock

  dynamic "admin_contact" {
    for_each = var.admin_contact != null ? [var.admin_contact] : []
    content {
      address_line_1    = admin_contact.value.address_line_1
      address_line_2    = admin_contact.value.address_line_2
      city              = admin_contact.value.city
      contact_type      = admin_contact.value.contact_type
      country_code      = admin_contact.value.country_code
      email             = admin_contact.value.email
      extra_params      = admin_contact.value.extra_params
      fax               = admin_contact.value.fax
      first_name        = admin_contact.value.first_name
      last_name         = admin_contact.value.last_name
      organization_name = admin_contact.value.organization_name
      phone_number      = admin_contact.value.phone_number
      state             = admin_contact.value.state
      zip_code          = admin_contact.value.zip_code
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
      extra_params      = billing_contact.value.extra_params
      fax               = billing_contact.value.fax
      first_name        = billing_contact.value.first_name
      last_name         = billing_contact.value.last_name
      organization_name = billing_contact.value.organization_name
      phone_number      = billing_contact.value.phone_number
      state             = billing_contact.value.state
      zip_code          = billing_contact.value.zip_code
    }
  }

  dynamic "registrant_contact" {
    for_each = var.registrant_contact != null ? [var.registrant_contact] : []
    content {
      address_line_1    = registrant_contact.value.address_line_1
      address_line_2    = registrant_contact.value.address_line_2
      city              = registrant_contact.value.city
      contact_type      = registrant_contact.value.contact_type
      country_code      = registrant_contact.value.country_code
      email             = registrant_contact.value.email
      extra_params      = registrant_contact.value.extra_params
      fax               = registrant_contact.value.fax
      first_name        = registrant_contact.value.first_name
      last_name         = registrant_contact.value.last_name
      organization_name = registrant_contact.value.organization_name
      phone_number      = registrant_contact.value.phone_number
      state             = registrant_contact.value.state
      zip_code          = registrant_contact.value.zip_code
    }
  }

  dynamic "tech_contact" {
    for_each = var.tech_contact != null ? [var.tech_contact] : []
    content {
      address_line_1    = tech_contact.value.address_line_1
      address_line_2    = tech_contact.value.address_line_2
      city              = tech_contact.value.city
      contact_type      = tech_contact.value.contact_type
      country_code      = tech_contact.value.country_code
      email             = tech_contact.value.email
      extra_params      = tech_contact.value.extra_params
      fax               = tech_contact.value.fax
      first_name        = tech_contact.value.first_name
      last_name         = tech_contact.value.last_name
      organization_name = tech_contact.value.organization_name
      phone_number      = tech_contact.value.phone_number
      state             = tech_contact.value.state
      zip_code          = tech_contact.value.zip_code
    }
  }

  dynamic "name_server" {
    for_each = var.name_server
    content {
      name     = name_server.value.name
      glue_ips = name_server.value.glue_ips
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}