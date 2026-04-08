output "arn" {
  description = "The domain's ARN."
  value       = aws_cloudsearch_domain.this.arn
}

output "document_service_endpoint" {
  description = "The service endpoint for updating documents in a search domain."
  value       = aws_cloudsearch_domain.this.document_service_endpoint
}

output "domain_id" {
  description = "An internally generated unique identifier for the domain."
  value       = aws_cloudsearch_domain.this.domain_id
}

output "search_service_endpoint" {
  description = "The service endpoint for requesting search results from a search domain."
  value       = aws_cloudsearch_domain.this.search_service_endpoint
}

output "name" {
  description = "The name of the CloudSearch domain."
  value       = aws_cloudsearch_domain.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudsearch_domain.this.region
}

output "multi_az" {
  description = "Whether or not to maintain extra instances for the domain in a second Availability Zone to ensure high availability."
  value       = aws_cloudsearch_domain.this.multi_az
}

output "endpoint_options" {
  description = "Domain endpoint options."
  value       = aws_cloudsearch_domain.this.endpoint_options
}

output "scaling_parameters" {
  description = "Domain scaling parameters."
  value       = aws_cloudsearch_domain.this.scaling_parameters
}

output "index_field" {
  description = "The index fields for documents added to the domain."
  value       = aws_cloudsearch_domain.this.index_field
}