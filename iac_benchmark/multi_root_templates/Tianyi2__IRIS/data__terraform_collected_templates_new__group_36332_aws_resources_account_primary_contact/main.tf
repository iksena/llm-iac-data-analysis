resource "aws_account_primary_contact" "this" {
  account_id         = var.account_id
  address_line_1     = var.address_line_1
  address_line_2     = var.address_line_2
  address_line_3     = var.address_line_3
  city               = var.city
  company_name       = var.company_name
  country_code       = var.country_code
  district_or_county = var.district_or_county
  full_name          = var.full_name
  phone_number       = var.phone_number
  postal_code        = var.postal_code
  state_or_region    = var.state_or_region
  website_url        = var.website_url
}