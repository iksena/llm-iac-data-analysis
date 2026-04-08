output "arn" {
  description = "The ARN of the topic rule destination"
  value       = aws_iot_topic_rule_destination.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_iot_topic_rule_destination.this.region
}

output "enabled" {
  description = "Whether or not the destination is enabled"
  value       = aws_iot_topic_rule_destination.this.enabled
}

output "vpc_configuration" {
  description = "Configuration of the virtual private cloud (VPC) connection"
  value       = aws_iot_topic_rule_destination.this.vpc_configuration
}