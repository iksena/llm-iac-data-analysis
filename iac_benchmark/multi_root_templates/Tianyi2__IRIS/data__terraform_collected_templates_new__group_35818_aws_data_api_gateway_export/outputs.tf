output "id" {
  description = "The REST-API-ID:STAGE-NAME"
  value       = data.aws_api_gateway_export.this.id
}

output "body" {
  description = "API Spec"
  value       = data.aws_api_gateway_export.this.body
}

output "content_type" {
  description = "Content-type header value in the HTTP response"
  value       = data.aws_api_gateway_export.this.content_type
}

output "content_disposition" {
  description = "Content-disposition header value in the HTTP response"
  value       = data.aws_api_gateway_export.this.content_disposition
}

output "rest_api_id" {
  description = "Identifier of the associated REST API"
  value       = data.aws_api_gateway_export.this.rest_api_id
}

output "stage_name" {
  description = "Name of the Stage that will be exported"
  value       = data.aws_api_gateway_export.this.stage_name
}

output "export_type" {
  description = "Type of export"
  value       = data.aws_api_gateway_export.this.export_type
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_api_gateway_export.this.region
}

output "accepts" {
  description = "Content-type of the export"
  value       = data.aws_api_gateway_export.this.accepts
}

output "parameters" {
  description = "Key-value map of query string parameters"
  value       = data.aws_api_gateway_export.this.parameters
}