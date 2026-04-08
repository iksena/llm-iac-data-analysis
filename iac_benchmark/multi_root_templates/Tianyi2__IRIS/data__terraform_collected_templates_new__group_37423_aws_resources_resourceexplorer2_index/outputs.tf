output "arn" {
  description = "Amazon Resource Name (ARN) of the Resource Explorer index."
  value       = aws_resourceexplorer2_index.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_resourceexplorer2_index.this.region
}

output "type" {
  description = "The type of the index."
  value       = aws_resourceexplorer2_index.this.type
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_resourceexplorer2_index.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_resourceexplorer2_index.this.tags_all
}