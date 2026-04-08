output "id" {
  description = "The AWS Region the Servicecatalog portfolio status resides in."
  value       = aws_sagemaker_servicecatalog_portfolio_status.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_sagemaker_servicecatalog_portfolio_status.this.region
}

output "status" {
  description = "Whether Service Catalog is enabled or disabled in SageMaker."
  value       = aws_sagemaker_servicecatalog_portfolio_status.this.status
}