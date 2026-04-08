output "action_id" {
  description = "The id of the budget action."
  value       = aws_budgets_budget_action.this.action_id
}

output "id" {
  description = "ID of resource."
  value       = aws_budgets_budget_action.this.id
}

output "arn" {
  description = "The ARN of the budget action."
  value       = aws_budgets_budget_action.this.arn
}

output "status" {
  description = "The status of the budget action."
  value       = aws_budgets_budget_action.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_budgets_budget_action.this.tags_all
}