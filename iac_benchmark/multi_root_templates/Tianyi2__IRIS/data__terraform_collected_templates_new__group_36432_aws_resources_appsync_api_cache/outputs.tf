output "id" {
  description = "AppSync API ID."
  value       = aws_appsync_api_cache.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_appsync_api_cache.this.region
}

output "api_id" {
  description = "GraphQL API ID."
  value       = aws_appsync_api_cache.this.api_id
}

output "api_caching_behavior" {
  description = "Caching behavior."
  value       = aws_appsync_api_cache.this.api_caching_behavior
}

output "type" {
  description = "Cache instance type."
  value       = aws_appsync_api_cache.this.type
}

output "ttl" {
  description = "TTL in seconds for cache entries."
  value       = aws_appsync_api_cache.this.ttl
}

output "at_rest_encryption_enabled" {
  description = "At-rest encryption flag for cache."
  value       = aws_appsync_api_cache.this.at_rest_encryption_enabled
}

output "transit_encryption_enabled" {
  description = "Transit encryption flag when connecting to cache."
  value       = aws_appsync_api_cache.this.transit_encryption_enabled
}