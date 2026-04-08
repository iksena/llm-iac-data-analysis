output "id" {
  description = "Constraint identifier"
  value       = data.aws_servicecatalog_constraint.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_servicecatalog_constraint.this.region
}

output "accept_language" {
  description = "Language code"
  value       = data.aws_servicecatalog_constraint.this.accept_language
}

output "description" {
  description = "Description of the constraint"
  value       = data.aws_servicecatalog_constraint.this.description
}

output "owner" {
  description = "Owner of the constraint"
  value       = data.aws_servicecatalog_constraint.this.owner
}

output "parameters" {
  description = "Constraint parameters in JSON format"
  value       = data.aws_servicecatalog_constraint.this.parameters
}

output "portfolio_id" {
  description = "Portfolio identifier"
  value       = data.aws_servicecatalog_constraint.this.portfolio_id
}

output "product_id" {
  description = "Product identifier"
  value       = data.aws_servicecatalog_constraint.this.product_id
}

output "status" {
  description = "Constraint status"
  value       = data.aws_servicecatalog_constraint.this.status
}

output "type" {
  description = "Type of constraint. Valid values are LAUNCH, NOTIFICATION, RESOURCE_UPDATE, STACKSET, and TEMPLATE"
  value       = data.aws_servicecatalog_constraint.this.type
}