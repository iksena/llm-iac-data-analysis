output "arn" {
  description = "ARN of the block list"
  value       = aws_kendra_query_suggestions_block_list.this.arn
}

output "query_suggestions_block_list_id" {
  description = "Unique identifier of the block list"
  value       = aws_kendra_query_suggestions_block_list.this.query_suggestions_block_list_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider's default_tags configuration block"
  value       = aws_kendra_query_suggestions_block_list.this.tags_all
}