output "id" {
  description = "The unique identifier (ID) of the macie account."
  value       = aws_macie2_account.this.id
}

output "service_role" {
  description = "The Amazon Resource Name (ARN) of the service-linked role that allows Macie to monitor and analyze data in AWS resources for the account."
  value       = aws_macie2_account.this.service_role
}

output "created_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie account was created."
  value       = aws_macie2_account.this.created_at
}

output "updated_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, of the most recent change to the status of the Macie account."
  value       = aws_macie2_account.this.updated_at
}