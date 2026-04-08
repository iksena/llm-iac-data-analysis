output "arn" {
  description = "The Amazon Resource Name (ARN) of the contact or escalation plan"
  value       = aws_ssmcontacts_contact.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ssmcontacts_contact.this.tags_all
}