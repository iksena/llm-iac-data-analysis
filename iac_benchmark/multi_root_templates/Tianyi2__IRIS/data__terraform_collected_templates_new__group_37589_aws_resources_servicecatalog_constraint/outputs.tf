output "id" {
  description = "Constraint identifier."
  value       = aws_servicecatalog_constraint.this.id
}

output "owner" {
  description = "Owner of the constraint."
  value       = aws_servicecatalog_constraint.this.owner
}

output "parameters" {
  description = "Constraint parameters in JSON format."
  value       = aws_servicecatalog_constraint.this.parameters
}

output "portfolio_id" {
  description = "Portfolio identifier."
  value       = aws_servicecatalog_constraint.this.portfolio_id
}

output "product_id" {
  description = "Product identifier."
  value       = aws_servicecatalog_constraint.this.product_id
}

output "type" {
  description = "Type of constraint."
  value       = aws_servicecatalog_constraint.this.type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_servicecatalog_constraint.this.region
}

output "accept_language" {
  description = "Language code."
  value       = aws_servicecatalog_constraint.this.accept_language
}

output "description" {
  description = "Description of the constraint."
  value       = aws_servicecatalog_constraint.this.description
}