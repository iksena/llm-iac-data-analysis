resource "aws_identitystore_user" "this" {
  display_name      = var.display_name
  identity_store_id = var.identity_store_id
  user_name         = var.user_name
  region            = var.region

  name {
    family_name      = var.name.family_name
    given_name       = var.name.given_name
    formatted        = var.name.formatted
    honorific_prefix = var.name.honorific_prefix
    honorific_suffix = var.name.honorific_suffix
    middle_name      = var.name.middle_name
  }

  dynamic "addresses" {
    for_each = var.addresses != null ? [var.addresses] : []
    content {
      country        = addresses.value.country
      formatted      = addresses.value.formatted
      locality       = addresses.value.locality
      postal_code    = addresses.value.postal_code
      primary        = addresses.value.primary
      region         = addresses.value.region
      street_address = addresses.value.street_address
      type           = addresses.value.type
    }
  }

  dynamic "emails" {
    for_each = var.emails != null ? [var.emails] : []
    content {
      primary = emails.value.primary
      type    = emails.value.type
      value   = emails.value.value
    }
  }

  dynamic "phone_numbers" {
    for_each = var.phone_numbers != null ? [var.phone_numbers] : []
    content {
      primary = phone_numbers.value.primary
      type    = phone_numbers.value.type
      value   = phone_numbers.value.value
    }
  }

  locale             = var.locale
  nickname           = var.nickname
  preferred_language = var.preferred_language
  profile_url        = var.profile_url
  timezone           = var.timezone
  title              = var.title
  user_type          = var.user_type
}