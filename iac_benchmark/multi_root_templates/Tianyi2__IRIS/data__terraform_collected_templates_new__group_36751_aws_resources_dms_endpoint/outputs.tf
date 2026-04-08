output "endpoint_arn" {
  description = "ARN for the endpoint."
  value       = aws_dms_endpoint.this.endpoint_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_endpoint.this.tags_all
}

output "endpoint_id" {
  description = "Database endpoint identifier."
  value       = aws_dms_endpoint.this.endpoint_id
}

output "endpoint_type" {
  description = "Type of endpoint."
  value       = aws_dms_endpoint.this.endpoint_type
}

output "engine_name" {
  description = "Type of engine for the endpoint."
  value       = aws_dms_endpoint.this.engine_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_dms_endpoint.this.region
}

output "certificate_arn" {
  description = "ARN for the certificate."
  value       = aws_dms_endpoint.this.certificate_arn
}

output "database_name" {
  description = "Name of the endpoint database."
  value       = aws_dms_endpoint.this.database_name
}

output "extra_connection_attributes" {
  description = "Additional attributes associated with the connection."
  value       = aws_dms_endpoint.this.extra_connection_attributes
}

output "kms_key_arn" {
  description = "ARN for the KMS key that will be used to encrypt the connection parameters."
  value       = aws_dms_endpoint.this.kms_key_arn
}

output "port" {
  description = "Port used by the endpoint database."
  value       = aws_dms_endpoint.this.port
}

output "server_name" {
  description = "Host name of the server."
  value       = aws_dms_endpoint.this.server_name
}

output "service_access_role" {
  description = "ARN used by the service access IAM role for dynamodb endpoints."
  value       = aws_dms_endpoint.this.service_access_role
}

output "ssl_mode" {
  description = "SSL mode to use for the connection."
  value       = aws_dms_endpoint.this.ssl_mode
}

output "username" {
  description = "User name to be used to login to the endpoint database."
  value       = aws_dms_endpoint.this.username
}

output "pause_replication_tasks" {
  description = "Whether to pause associated running replication tasks, regardless if they are managed by Terraform, prior to modifying the endpoint."
  value       = aws_dms_endpoint.this.pause_replication_tasks
}

output "secrets_manager_access_role_arn" {
  description = "ARN of the IAM role that specifies AWS DMS as the trusted entity and has the required permissions to access the value in the Secrets Manager secret referred to by secrets_manager_arn."
  value       = aws_dms_endpoint.this.secrets_manager_access_role_arn
}

output "secrets_manager_arn" {
  description = "Full ARN, partial ARN, or friendly name of the Secrets Manager secret that contains the endpoint connection details."
  value       = aws_dms_endpoint.this.secrets_manager_arn
}

output "tags" {
  description = "Map of tags to assign to the resource."
  value       = aws_dms_endpoint.this.tags
}

output "elasticsearch_settings" {
  description = "Configuration block for OpenSearch settings."
  value       = aws_dms_endpoint.this.elasticsearch_settings
}

output "kafka_settings" {
  description = "Configuration block for Kafka settings."
  value       = aws_dms_endpoint.this.kafka_settings
}

output "kinesis_settings" {
  description = "Configuration block for Kinesis settings."
  value       = aws_dms_endpoint.this.kinesis_settings
}

output "mongodb_settings" {
  description = "Configuration block for MongoDB settings."
  value       = aws_dms_endpoint.this.mongodb_settings
}

output "oracle_settings" {
  description = "Configuration block for Oracle settings."
  value       = aws_dms_endpoint.this.oracle_settings
}

output "postgres_settings" {
  description = "Configuration block for Postgres settings."
  value       = aws_dms_endpoint.this.postgres_settings
}

output "redis_settings" {
  description = "Configuration block for Redis settings."
  value       = aws_dms_endpoint.this.redis_settings
}

output "redshift_settings" {
  description = "Configuration block for Redshift settings."
  value       = aws_dms_endpoint.this.redshift_settings
}