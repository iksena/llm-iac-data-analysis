output "id" {
  description = "The ID of the Service Catalog Portfolio."
  value       = aws_servicecatalog_portfolio.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_servicecatalog_portfolio.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_servicecatalog_portfolio.this.region
}

output "name" {
  description = "The name of the portfolio."
  value       = aws_servicecatalog_portfolio.this.name
}

output "description" {
  description = "Description of the portfolio."
  value       = aws_servicecatalog_portfolio.this.description
}

output "provider_name" {
  description = "Name of the person or organization who owns the portfolio."
  value       = aws_servicecatalog_portfolio.this.provider_name
}

output "tags" {
  description = "Tags applied to the connection."
  value       = aws_servicecatalog_portfolio.this.tags
}