output "arn" {
  description = "The Amazon Resource Name (ARN) of the rotation."
  value       = aws_ssmcontacts_rotation.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssmcontacts_rotation.this.tags_all
}