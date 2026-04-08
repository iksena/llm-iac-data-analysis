output "details" {
  description = "List of information about the constraints"
  value       = data.aws_servicecatalog_portfolio_constraints.this.details
}

output "constraint_id" {
  description = "Identifier of the constraint"
  value       = try(data.aws_servicecatalog_portfolio_constraints.this.details[*].constraint_id, [])
}

output "constraint_description" {
  description = "Description of the constraint"
  value       = try(data.aws_servicecatalog_portfolio_constraints.this.details[*].description, [])
}

output "portfolio_id" {
  description = "Identifier of the portfolio the product resides in"
  value       = try(data.aws_servicecatalog_portfolio_constraints.this.details[*].portfolio_id, [])
}

output "product_id" {
  description = "Identifier of the product the constraint applies to"
  value       = try(data.aws_servicecatalog_portfolio_constraints.this.details[*].product_id, [])
}

output "type" {
  description = "Type of constraint. Valid values are LAUNCH, NOTIFICATION, STACKSET, and TEMPLATE"
  value       = try(data.aws_servicecatalog_portfolio_constraints.this.details[*].type, [])
}