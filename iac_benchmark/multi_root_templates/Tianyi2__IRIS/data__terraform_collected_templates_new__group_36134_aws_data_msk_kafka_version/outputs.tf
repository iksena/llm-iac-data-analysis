output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_msk_kafka_version.this.region
}

output "preferred_versions" {
  description = "Ordered list of preferred Kafka versions"
  value       = data.aws_msk_kafka_version.this.preferred_versions
}

output "version" {
  description = "Version of MSK Kafka"
  value       = data.aws_msk_kafka_version.this.version
}

output "status" {
  description = "Status of the MSK Kafka version eg. ACTIVE or DEPRECATED"
  value       = data.aws_msk_kafka_version.this.status
}