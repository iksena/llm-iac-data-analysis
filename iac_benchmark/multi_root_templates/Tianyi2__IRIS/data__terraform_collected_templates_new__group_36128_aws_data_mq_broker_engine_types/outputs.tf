output "broker_engine_types" {
  description = "List of available engine types and versions"
  value       = data.aws_mq_broker_engine_types.this.broker_engine_types
}