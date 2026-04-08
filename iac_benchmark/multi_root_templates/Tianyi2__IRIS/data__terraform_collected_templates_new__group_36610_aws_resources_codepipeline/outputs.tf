output "id" {
  description = "Codepipeline ID"
  value       = aws_codepipeline.this.id
}

output "arn" {
  description = "Codepipeline ARN"
  value       = aws_codepipeline.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_codepipeline.this.tags_all
}

output "trigger_all" {
  description = "A list of all triggers present on the pipeline, including default triggers added by AWS for V2 pipelines which omit an explicit trigger definition"
  value       = aws_codepipeline.this.trigger_all
}