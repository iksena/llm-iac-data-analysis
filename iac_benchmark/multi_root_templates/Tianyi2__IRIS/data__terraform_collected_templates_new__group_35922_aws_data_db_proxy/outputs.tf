output "name" {
  description = "Name of the DB proxy"
  value       = data.aws_db_proxy.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_db_proxy.this.region
}

output "arn" {
  description = "ARN of the DB Proxy"
  value       = data.aws_db_proxy.this.arn
}

output "auth" {
  description = "Configuration(s) with authorization mechanisms to connect to the associated instance or cluster"
  value       = data.aws_db_proxy.this.auth
}

output "debug_logging" {
  description = "Whether the proxy includes detailed information about SQL statements in its logs"
  value       = data.aws_db_proxy.this.debug_logging
}

output "endpoint" {
  description = "Endpoint that you can use to connect to the DB proxy"
  value       = data.aws_db_proxy.this.endpoint
}

output "engine_family" {
  description = "Kinds of databases that the proxy can connect to"
  value       = data.aws_db_proxy.this.engine_family
}

output "idle_client_timeout" {
  description = "Number of seconds a connection to the proxy can have no activity before the proxy drops the client connection"
  value       = data.aws_db_proxy.this.idle_client_timeout
}

output "require_tls" {
  description = "Whether Transport Layer Security (TLS) encryption is required for connections to the proxy"
  value       = data.aws_db_proxy.this.require_tls
}

output "role_arn" {
  description = "ARN for the IAM role that the proxy uses to access Amazon Secrets Manager"
  value       = data.aws_db_proxy.this.role_arn
}

output "vpc_id" {
  description = "VPC ID of the DB proxy"
  value       = data.aws_db_proxy.this.vpc_id
}

output "vpc_security_group_ids" {
  description = "List of VPC security groups that the proxy belongs to"
  value       = data.aws_db_proxy.this.vpc_security_group_ids
}

output "vpc_subnet_ids" {
  description = "EC2 subnet IDs for the proxy"
  value       = data.aws_db_proxy.this.vpc_subnet_ids
}