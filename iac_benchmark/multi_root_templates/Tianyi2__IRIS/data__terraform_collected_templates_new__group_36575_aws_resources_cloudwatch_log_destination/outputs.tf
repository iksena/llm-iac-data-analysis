output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the log destination"
  value       = aws_cloudwatch_log_destination.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudwatch_log_destination.this.tags_all
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_cloudwatch_log_destination.this.region
}

output "name" {
  description = "The name for the log destination"
  value       = aws_cloudwatch_log_destination.this.name
}

output "role_arn" {
  description = "The ARN of the IAM role that grants Amazon CloudWatch Logs permissions"
  value       = aws_cloudwatch_log_destination.this.role_arn
}

output "target_arn" {
  description = "The ARN of the target Amazon Kinesis stream resource"
  value       = aws_cloudwatch_log_destination.this.target_arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_cloudwatch_log_destination.this.tags
}