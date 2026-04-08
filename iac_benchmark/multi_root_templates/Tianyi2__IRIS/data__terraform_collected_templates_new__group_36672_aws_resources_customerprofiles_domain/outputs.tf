output "arn" {
  description = "The Amazon Resource Name (ARN) of the Customer Profiles Domain."
  value       = aws_customerprofiles_domain.this.arn
}

output "id" {
  description = "The identifier of the Customer Profiles Domain."
  value       = aws_customerprofiles_domain.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_customerprofiles_domain.this.tags_all
}