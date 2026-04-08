output "endpoint_arn" {
  description = "ARN for the endpoint"
  value       = aws_dms_s3_endpoint.this.endpoint_arn
}

output "engine_display_name" {
  description = "Expanded name for the engine name"
  value       = aws_dms_s3_endpoint.this.engine_display_name
}

output "external_id" {
  description = "Can be used for cross-account validation. Use it in another account with aws_dms_s3_endpoint to create the endpoint cross-account"
  value       = aws_dms_s3_endpoint.this.external_id
}

output "status" {
  description = "Status of the endpoint"
  value       = aws_dms_s3_endpoint.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dms_s3_endpoint.this.tags_all
}