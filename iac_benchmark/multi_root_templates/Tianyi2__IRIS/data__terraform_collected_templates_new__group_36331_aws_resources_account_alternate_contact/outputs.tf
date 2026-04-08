output "account_id" {
  description = "ID of the target account."
  value       = aws_account_alternate_contact.this.account_id
}

output "alternate_contact_type" {
  description = "Type of the alternate contact."
  value       = aws_account_alternate_contact.this.alternate_contact_type
}

output "email_address" {
  description = "Email address of the alternate contact."
  value       = aws_account_alternate_contact.this.email_address
}

output "name" {
  description = "Name of the alternate contact."
  value       = aws_account_alternate_contact.this.name
}

output "phone_number" {
  description = "Phone number of the alternate contact."
  value       = aws_account_alternate_contact.this.phone_number
}

output "title" {
  description = "Title of the alternate contact."
  value       = aws_account_alternate_contact.this.title
}