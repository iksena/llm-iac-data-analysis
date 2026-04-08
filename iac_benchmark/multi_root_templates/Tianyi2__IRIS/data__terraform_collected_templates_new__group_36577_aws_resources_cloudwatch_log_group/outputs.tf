output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudwatch_log_group.this.region
}

output "name" {
  description = "The name of the log group."
  value       = aws_cloudwatch_log_group.this.name
}

output "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  value       = aws_cloudwatch_log_group.this.name_prefix
}

output "skip_destroy" {
  description = "Whether the log group is set to skip destroy."
  value       = aws_cloudwatch_log_group.this.skip_destroy
}

output "log_group_class" {
  description = "The log class of the log group."
  value       = aws_cloudwatch_log_group.this.log_group_class
}

output "retention_in_days" {
  description = "The number of days log events are retained in the log group."
  value       = aws_cloudwatch_log_group.this.retention_in_days
}

output "kms_key_id" {
  description = "The ARN of the KMS Key used for encrypting log data."
  value       = aws_cloudwatch_log_group.this.kms_key_id
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_cloudwatch_log_group.this.tags
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the log group."
  value       = aws_cloudwatch_log_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_log_group.this.tags_all
}