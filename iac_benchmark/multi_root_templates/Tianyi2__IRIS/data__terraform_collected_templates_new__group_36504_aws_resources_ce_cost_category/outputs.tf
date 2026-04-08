output "arn" {
  description = "ARN of the cost category"
  value       = aws_ce_cost_category.this.arn
}

output "effective_end" {
  description = "Effective end data of your Cost Category"
  value       = aws_ce_cost_category.this.effective_end
}

output "id" {
  description = "Unique ID of the cost category"
  value       = aws_ce_cost_category.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ce_cost_category.this.tags_all
}