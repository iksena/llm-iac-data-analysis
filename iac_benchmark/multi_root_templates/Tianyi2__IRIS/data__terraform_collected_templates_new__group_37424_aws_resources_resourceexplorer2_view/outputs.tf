output "arn" {
  description = "Amazon Resource Name (ARN) of the Resource Explorer view."
  value       = aws_resourceexplorer2_view.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_resourceexplorer2_view.this.tags_all
}