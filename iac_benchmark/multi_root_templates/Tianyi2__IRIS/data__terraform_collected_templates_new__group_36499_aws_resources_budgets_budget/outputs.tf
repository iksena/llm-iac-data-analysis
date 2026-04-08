output "arn" {
  description = "The ARN of the budget."
  value       = aws_budgets_budget.this.arn
}

output "id" {
  description = "ID of the budget resource."
  value       = aws_budgets_budget.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_budgets_budget.this.tags_all
}