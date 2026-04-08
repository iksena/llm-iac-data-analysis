output "auto_adjust_data" {
  description = "Object containing AutoAdjustData which determines the budget amount for an auto-adjusting budget."
  value       = data.aws_budgets_budget.this.auto_adjust_data
}

output "budget_exceeded" {
  description = "Boolean indicating whether this budget has been exceeded."
  value       = data.aws_budgets_budget.this.budget_exceeded
}

output "budget_limit" {
  description = "The total amount of cost, usage, RI utilization, RI coverage, Savings Plans utilization, or Savings Plans coverage that you want to track with your budget."
  value       = data.aws_budgets_budget.this.budget_limit
}

output "budget_type" {
  description = "Whether this budget tracks monetary cost or usage."
  value       = data.aws_budgets_budget.this.budget_type
}

output "calculated_spend" {
  description = "The spend objects that are associated with this budget. The actualSpend tracks how much you've used, cost, usage, RI units, or Savings Plans units and the forecastedSpend tracks how much that you're predicted to spend based on your historical usage profile."
  value       = data.aws_budgets_budget.this.calculated_spend
}

output "cost_filter" {
  description = "A list of CostFilter name/values pair to apply to budget."
  value       = data.aws_budgets_budget.this.cost_filter
}

output "cost_types" {
  description = "Object containing CostTypes The types of cost included in a budget, such as tax and subscriptions."
  value       = data.aws_budgets_budget.this.cost_types
}

output "notification" {
  description = "Object containing Budget Notifications. Can be used multiple times to define more than one budget notification."
  value       = data.aws_budgets_budget.this.notification
}

output "planned_limit" {
  description = "Object containing Planned Budget Limits. Can be used multiple times to plan more than one budget limit."
  value       = data.aws_budgets_budget.this.planned_limit
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_budgets_budget.this.tags
}

output "time_period_end" {
  description = "The end of the time period covered by the budget. There are no restrictions on the end date. Format: 2017-01-01_12:00."
  value       = data.aws_budgets_budget.this.time_period_end
}

output "time_period_start" {
  description = "The start of the time period covered by the budget. If you don't specify a start date, AWS defaults to the start of your chosen time period. The start date must come before the end date. Format: 2017-01-01_12:00."
  value       = data.aws_budgets_budget.this.time_period_start
}

output "time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY, and DAILY."
  value       = data.aws_budgets_budget.this.time_unit
}

output "name" {
  description = "The name of a budget. Unique within accounts."
  value       = data.aws_budgets_budget.this.name
}

output "account_id" {
  description = "The ID of the target account for budget."
  value       = data.aws_budgets_budget.this.account_id
}

output "name_prefix" {
  description = "The prefix of the name of a budget. Unique within accounts."
  value       = data.aws_budgets_budget.this.name_prefix
}

output "billing_view_arn" {
  description = "ARN of the billing view."
  value       = data.aws_budgets_budget.this.billing_view_arn
}