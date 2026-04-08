output "arn" {
  description = "The Amazon Resource Name (ARN) of the serverless cache."
  value       = aws_elasticache_serverless_cache.this.arn
}

output "create_time" {
  description = "Timestamp of when the serverless cache was created."
  value       = aws_elasticache_serverless_cache.this.create_time
}

output "endpoint" {
  description = "Represents the information required for client programs to connect to a cache node."
  value = {
    address = aws_elasticache_serverless_cache.this.endpoint[0].address
    port    = aws_elasticache_serverless_cache.this.endpoint[0].port
  }
}

output "full_engine_version" {
  description = "The name and version number of the engine the serverless cache is compatible with."
  value       = aws_elasticache_serverless_cache.this.full_engine_version
}

output "major_engine_version" {
  description = "The version number of the engine the serverless cache is compatible with."
  value       = aws_elasticache_serverless_cache.this.major_engine_version
}

output "reader_endpoint" {
  description = "Represents the information required for client programs to connect to a cache node."
  value = length(aws_elasticache_serverless_cache.this.reader_endpoint) > 0 ? {
    address = aws_elasticache_serverless_cache.this.reader_endpoint[0].address
    port    = aws_elasticache_serverless_cache.this.reader_endpoint[0].port
  } : null
}

output "status" {
  description = "The current status of the serverless cache. The allowed values are CREATING, AVAILABLE, DELETING, CREATE-FAILED and MODIFYING."
  value       = aws_elasticache_serverless_cache.this.status
}