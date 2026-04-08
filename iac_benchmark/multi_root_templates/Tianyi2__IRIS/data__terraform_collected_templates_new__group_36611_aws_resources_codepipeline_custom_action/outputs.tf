output "id" {
  description = "Composed of category, provider and version. For example, Build:terraform:1"
  value       = aws_codepipeline_custom_action_type.this.id
}

output "arn" {
  description = "The action ARN."
  value       = aws_codepipeline_custom_action_type.this.arn
}

output "owner" {
  description = "The creator of the action being called."
  value       = aws_codepipeline_custom_action_type.this.owner
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codepipeline_custom_action_type.this.tags_all
}