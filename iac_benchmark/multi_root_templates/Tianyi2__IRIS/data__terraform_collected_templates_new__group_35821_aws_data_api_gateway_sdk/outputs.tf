output "id" {
  description = "The REST-API-ID:STAGE-NAME"
  value       = data.aws_api_gateway_sdk.this.id
}

output "body" {
  description = "SDK as a string."
  value       = data.aws_api_gateway_sdk.this.body
}

output "content_type" {
  description = "Content-type header value in the HTTP response."
  value       = data.aws_api_gateway_sdk.this.content_type
}

output "content_disposition" {
  description = "Content-disposition header value in the HTTP response."
  value       = data.aws_api_gateway_sdk.this.content_disposition
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_api_gateway_sdk.this.region
}

output "rest_api_id" {
  description = "Identifier of the associated REST API."
  value       = data.aws_api_gateway_sdk.this.rest_api_id
}

output "stage_name" {
  description = "Name of the Stage that will be exported."
  value       = data.aws_api_gateway_sdk.this.stage_name
}

output "sdk_type" {
  description = "Language for the generated SDK."
  value       = data.aws_api_gateway_sdk.this.sdk_type
}

output "parameters" {
  description = "Key-value map of query string parameters sdk_type properties of the SDK."
  value       = data.aws_api_gateway_sdk.this.parameters
}