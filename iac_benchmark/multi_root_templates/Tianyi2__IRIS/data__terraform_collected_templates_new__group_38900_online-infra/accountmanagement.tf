resource "aws_account_primary_contact" "root" {
  address_line_1     = "Sem Sælands vei 9"
  city               = "Trondheim"
  company_name       = "ONLINE LINJEFORENINGEN FOR INFORMATIKK"
  country_code       = "NO"
  district_or_county = "Trondheim"
  full_name          = "Frederik Farstad"
  phone_number       = "+4747358919"
  postal_code        = "7034"
  state_or_region    = "Trondheim"
  website_url        = "https://online.ntnu.no"
}

resource "aws_account_alternate_contact" "operations" {
  alternate_contact_type = "OPERATIONS"

  name          = "Mats Jun Larsen"
  title         = "Operations and Security Manager"
  email_address = "mats.jun.larsen@online.ntnu.no"
  phone_number  = "+47 484 04 877"
}

resource "aws_account_alternate_contact" "billing" {
  alternate_contact_type = "BILLING"

  name          = "Mads Bårnes"
  title         = "Financial Manager"
  email_address = "mads.barnes@online.ntnu.no"
  phone_number  = "+47 954 89 711"
}

resource "aws_account_alternate_contact" "security" {
  alternate_contact_type = "SECURITY"

  name          = "Mats Jun Larsen"
  title         = "Operations and Security Manager"
  email_address = "mats.jun.larsen@online.ntnu.no"
  phone_number  = "+47 484 04 877"
}