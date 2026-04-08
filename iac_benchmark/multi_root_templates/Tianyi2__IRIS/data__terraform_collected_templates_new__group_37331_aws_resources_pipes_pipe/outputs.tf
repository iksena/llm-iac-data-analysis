output "arn" {
  description = "ARN of this pipe"
  value       = aws_pipes_pipe.this.arn
}

output "id" {
  description = "Same as name"
  value       = aws_pipes_pipe.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_pipes_pipe.this.tags_all
}