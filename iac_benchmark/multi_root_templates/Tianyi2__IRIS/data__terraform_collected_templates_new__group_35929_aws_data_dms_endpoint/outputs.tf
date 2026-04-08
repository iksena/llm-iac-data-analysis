output "endpoint_id" {
  description = "Database endpoint identifier"
  value       = data.aws_dms_endpoint.this.endpoint_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_dms_endpoint.this.region
}

output "endpoint_arn" {
  description = "ARN for the endpoint"
  value       = data.aws_dms_endpoint.this.endpoint_arn
}

output "endpoint_type" {
  description = "Type of endpoint"
  value       = data.aws_dms_endpoint.this.endpoint_type
}

output "engine_name" {
  description = "Type of engine for the endpoint"
  value       = data.aws_dms_endpoint.this.engine_name
}

output "certificate_arn" {
  description = "ARN for the certificate"
  value       = data.aws_dms_endpoint.this.certificate_arn
}

output "database_name" {
  description = "Name of the endpoint database"
  value       = data.aws_dms_endpoint.this.database_name
}

output "extra_connection_attributes" {
  description = "Additional attributes associated with the connection"
  value       = data.aws_dms_endpoint.this.extra_connection_attributes
}

output "kms_key_arn" {
  description = "ARN for the KMS key that will be used to encrypt the connection parameters"
  value       = data.aws_dms_endpoint.this.kms_key_arn
}

output "password" {
  description = "Password to be used to login to the endpoint database"
  value       = data.aws_dms_endpoint.this.password
  sensitive   = true
}

output "port" {
  description = "Port used by the endpoint database"
  value       = data.aws_dms_endpoint.this.port
}

output "server_name" {
  description = "Host name of the server"
  value       = data.aws_dms_endpoint.this.server_name
}

output "service_access_role" {
  description = "ARN used by the service access IAM role for dynamodb endpoints"
  value       = data.aws_dms_endpoint.this.service_access_role
}

output "ssl_mode" {
  description = "SSL mode to use for the connection"
  value       = data.aws_dms_endpoint.this.ssl_mode
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_dms_endpoint.this.tags
}

output "username" {
  description = "User name to be used to login to the endpoint database"
  value       = data.aws_dms_endpoint.this.username
}

output "elasticsearch_settings" {
  description = "Settings for the Elasticsearch target endpoint"
  value       = data.aws_dms_endpoint.this.elasticsearch_settings
}

output "kafka_settings" {
  description = "Settings for the Kafka target endpoint"
  value       = data.aws_dms_endpoint.this.kafka_settings
}

output "kinesis_settings" {
  description = "Settings for the Kinesis target endpoint"
  value       = data.aws_dms_endpoint.this.kinesis_settings
}

output "mongodb_settings" {
  description = "Settings for the MongoDB source endpoint"
  value       = data.aws_dms_endpoint.this.mongodb_settings
}

output "redshift_settings" {
  description = "Settings for the Redshift target endpoint"
  value       = data.aws_dms_endpoint.this.redshift_settings
}

output "s3_settings" {
  description = "Settings for the S3 target endpoint"
  value       = data.aws_dms_endpoint.this.s3_settings
}