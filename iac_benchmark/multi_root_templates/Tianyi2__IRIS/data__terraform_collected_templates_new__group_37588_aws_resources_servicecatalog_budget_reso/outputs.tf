output "id" {
  description = "Identifier of the association"
  value       = aws_servicecatalog_budget_resource_association.this.id
}

output "budget_name" {
  description = "Budget name"
  value       = aws_servicecatalog_budget_resource_association.this.budget_name
}

output "resource_id" {
  description = "Resource identifier"
  value       = aws_servicecatalog_budget_resource_association.this.resource_id
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_servicecatalog_budget_resource_association.this.region
}