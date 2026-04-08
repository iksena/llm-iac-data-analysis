output "id" {
  description = "Identifier of the association."
  value       = aws_servicecatalog_principal_portfolio_association.this.id
}

output "portfolio_id" {
  description = "Portfolio identifier."
  value       = aws_servicecatalog_principal_portfolio_association.this.portfolio_id
}

output "principal_arn" {
  description = "Principal ARN."
  value       = aws_servicecatalog_principal_portfolio_association.this.principal_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_servicecatalog_principal_portfolio_association.this.region
}

output "accept_language" {
  description = "Language code."
  value       = aws_servicecatalog_principal_portfolio_association.this.accept_language
}

output "principal_type" {
  description = "Principal type."
  value       = aws_servicecatalog_principal_portfolio_association.this.principal_type
}