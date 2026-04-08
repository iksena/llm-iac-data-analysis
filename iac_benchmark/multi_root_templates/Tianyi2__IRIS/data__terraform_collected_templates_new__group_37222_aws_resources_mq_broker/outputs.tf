output "arn" {
  description = "ARN of the broker"
  value       = aws_mq_broker.this.arn
}

output "id" {
  description = "Unique ID that Amazon MQ generates for the broker"
  value       = aws_mq_broker.this.id
}

output "instances" {
  description = "List of information about allocated brokers (both active & standby)"
  value       = aws_mq_broker.this.instances
}

output "instances_console_url" {
  description = "URL of the ActiveMQ Web Console or RabbitMQ Management UI"
  value       = try(aws_mq_broker.this.instances[0].console_url, null)
}

output "instances_ip_address" {
  description = "IP Address of the broker"
  value       = try(aws_mq_broker.this.instances[0].ip_address, null)
}

output "instances_endpoints" {
  description = "Broker's wire-level protocol endpoints"
  value       = try(aws_mq_broker.this.instances[0].endpoints, null)
}

output "pending_data_replication_mode" {
  description = "Data replication mode that will be applied after reboot"
  value       = aws_mq_broker.this.pending_data_replication_mode
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_mq_broker.this.tags_all
}