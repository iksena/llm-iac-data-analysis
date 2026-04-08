output "id" {
  description = "The unique identifier (ID) of the macie Member."
  value       = aws_macie2_member.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the account."
  value       = aws_macie2_member.this.arn
}

output "relationship_status" {
  description = "The current status of the relationship between the account and the administrator account."
  value       = aws_macie2_member.this.relationship_status
}

output "administrator_account_id" {
  description = "The AWS account ID for the administrator account."
  value       = aws_macie2_member.this.administrator_account_id
}

output "invited_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when an Amazon Macie membership invitation was last sent to the account. This value is null if a Macie invitation hasn't been sent to the account."
  value       = aws_macie2_member.this.invited_at
}

output "updated_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, of the most recent change to the status of the relationship between the account and the administrator account."
  value       = aws_macie2_member.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_macie2_member.this.tags_all
}