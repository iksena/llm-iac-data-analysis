output "arn" {
  description = "ARN of the thesaurus."
  value       = aws_kendra_thesaurus.this.arn
}

output "id" {
  description = "The unique identifiers of the thesaurus and index separated by a slash (/)."
  value       = aws_kendra_thesaurus.this.id
}

output "status" {
  description = "The current status of the thesaurus."
  value       = aws_kendra_thesaurus.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kendra_thesaurus.this.tags_all
}