output "id" {
  description = "Portfolio identifier"
  value       = data.aws_servicecatalog_portfolio.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_servicecatalog_portfolio.this.region
}

output "accept_language" {
  description = "Language code"
  value       = data.aws_servicecatalog_portfolio.this.accept_language
}

output "arn" {
  description = "Portfolio ARN"
  value       = data.aws_servicecatalog_portfolio.this.arn
}

output "created_time" {
  description = "Time the portfolio was created"
  value       = data.aws_servicecatalog_portfolio.this.created_time
}

output "description" {
  description = "Description of the portfolio"
  value       = data.aws_servicecatalog_portfolio.this.description
}

output "name" {
  description = "Portfolio name"
  value       = data.aws_servicecatalog_portfolio.this.name
}

output "provider_name" {
  description = "Name of the person or organization who owns the portfolio"
  value       = data.aws_servicecatalog_portfolio.this.provider_name
}

output "tags" {
  description = "Tags applied to the portfolio"
  value       = data.aws_servicecatalog_portfolio.this.tags
}