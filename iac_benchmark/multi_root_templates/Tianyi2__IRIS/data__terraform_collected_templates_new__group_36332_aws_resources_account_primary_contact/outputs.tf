output "account_id" {
  description = "The ID of the AWS account"
  value       = aws_account_primary_contact.this.account_id
}

output "address_line_1" {
  description = "The first line of the primary contact address"
  value       = aws_account_primary_contact.this.address_line_1
}

output "address_line_2" {
  description = "The second line of the primary contact address"
  value       = aws_account_primary_contact.this.address_line_2
}

output "address_line_3" {
  description = "The third line of the primary contact address"
  value       = aws_account_primary_contact.this.address_line_3
}

output "city" {
  description = "The city of the primary contact address"
  value       = aws_account_primary_contact.this.city
}

output "company_name" {
  description = "The name of the company associated with the primary contact information"
  value       = aws_account_primary_contact.this.company_name
}

output "country_code" {
  description = "The ISO-3166 two-letter country code for the primary contact address"
  value       = aws_account_primary_contact.this.country_code
}

output "district_or_county" {
  description = "The district or county of the primary contact address"
  value       = aws_account_primary_contact.this.district_or_county
}

output "full_name" {
  description = "The full name of the primary contact address"
  value       = aws_account_primary_contact.this.full_name
}

output "phone_number" {
  description = "The phone number of the primary contact information"
  value       = aws_account_primary_contact.this.phone_number
  sensitive   = true
}

output "postal_code" {
  description = "The postal code of the primary contact address"
  value       = aws_account_primary_contact.this.postal_code
}

output "state_or_region" {
  description = "The state or region of the primary contact address"
  value       = aws_account_primary_contact.this.state_or_region
}

output "website_url" {
  description = "The URL of the website associated with the primary contact information"
  value       = aws_account_primary_contact.this.website_url
}