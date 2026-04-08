resource "aws_customerprofiles_profile" "this" {
  domain_name = var.domain_name

  region                 = var.region
  account_number         = var.account_number
  additional_information = var.additional_information
  attributes             = var.attributes
  birth_date             = var.birth_date
  business_email_address = var.business_email_address
  business_name          = var.business_name
  business_phone_number  = var.business_phone_number
  email_address          = var.email_address
  first_name             = var.first_name
  gender_string          = var.gender_string
  home_phone_number      = var.home_phone_number
  last_name              = var.last_name
  middle_name            = var.middle_name
  mobile_phone_number    = var.mobile_phone_number
  party_type_string      = var.party_type_string
  personal_email_address = var.personal_email_address
  phone_number           = var.phone_number

  dynamic "address" {
    for_each = var.address != null ? [var.address] : []
    content {
      address_1   = address.value.address_1
      address_2   = address.value.address_2
      address_3   = address.value.address_3
      address_4   = address.value.address_4
      city        = address.value.city
      country     = address.value.country
      county      = address.value.county
      postal_code = address.value.postal_code
      province    = address.value.province
      state       = address.value.state
    }
  }

  dynamic "billing_address" {
    for_each = var.billing_address != null ? [var.billing_address] : []
    content {
      address_1   = billing_address.value.address_1
      address_2   = billing_address.value.address_2
      address_3   = billing_address.value.address_3
      address_4   = billing_address.value.address_4
      city        = billing_address.value.city
      country     = billing_address.value.country
      county      = billing_address.value.county
      postal_code = billing_address.value.postal_code
      province    = billing_address.value.province
      state       = billing_address.value.state
    }
  }

  dynamic "mailing_address" {
    for_each = var.mailing_address != null ? [var.mailing_address] : []
    content {
      address_1   = mailing_address.value.address_1
      address_2   = mailing_address.value.address_2
      address_3   = mailing_address.value.address_3
      address_4   = mailing_address.value.address_4
      city        = mailing_address.value.city
      country     = mailing_address.value.country
      county      = mailing_address.value.county
      postal_code = mailing_address.value.postal_code
      province    = mailing_address.value.province
      state       = mailing_address.value.state
    }
  }

  dynamic "shipping_address" {
    for_each = var.shipping_address != null ? [var.shipping_address] : []
    content {
      address_1   = shipping_address.value.address_1
      address_2   = shipping_address.value.address_2
      address_3   = shipping_address.value.address_3
      address_4   = shipping_address.value.address_4
      city        = shipping_address.value.city
      country     = shipping_address.value.country
      county      = shipping_address.value.county
      postal_code = shipping_address.value.postal_code
      province    = shipping_address.value.province
      state       = shipping_address.value.state
    }
  }

}