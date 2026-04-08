output "arn" {
  description = "ARN of the AppSync Resolver"
  value       = aws_appsync_resolver.this.arn
}

output "region" {
  description = "Region where the AppSync Resolver is managed"
  value       = aws_appsync_resolver.this.region
}

output "api_id" {
  description = "API ID for the GraphQL API"
  value       = aws_appsync_resolver.this.api_id
}

output "code" {
  description = "The function code that contains the request and response functions"
  value       = aws_appsync_resolver.this.code
}

output "type" {
  description = "Type name from the schema defined in the GraphQL API"
  value       = aws_appsync_resolver.this.type
}

output "field" {
  description = "Field name from the schema defined in the GraphQL API"
  value       = aws_appsync_resolver.this.field
}

output "request_template" {
  description = "Request mapping template for UNIT resolver or 'before mapping template' for PIPELINE resolver"
  value       = aws_appsync_resolver.this.request_template
}

output "response_template" {
  description = "Response mapping template for UNIT resolver or 'after mapping template' for PIPELINE resolver"
  value       = aws_appsync_resolver.this.response_template
}

output "data_source" {
  description = "Data source name"
  value       = aws_appsync_resolver.this.data_source
}

output "max_batch_size" {
  description = "Maximum batching size for a resolver"
  value       = aws_appsync_resolver.this.max_batch_size
}

output "kind" {
  description = "Resolver type"
  value       = aws_appsync_resolver.this.kind
}

output "sync_config" {
  description = "Sync configuration for the resolver"
  value       = aws_appsync_resolver.this.sync_config
}

output "pipeline_config" {
  description = "Pipeline configuration for the resolver"
  value       = aws_appsync_resolver.this.pipeline_config
}

output "caching_config" {
  description = "Caching configuration for the resolver"
  value       = aws_appsync_resolver.this.caching_config
}

output "runtime" {
  description = "Runtime configuration for the resolver"
  value       = aws_appsync_resolver.this.runtime
}