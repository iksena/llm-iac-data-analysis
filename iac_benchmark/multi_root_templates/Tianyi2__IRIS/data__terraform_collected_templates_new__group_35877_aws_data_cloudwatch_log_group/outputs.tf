output "arn" {
  description = "ARN of the Cloudwatch log group. Any `:*` suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix."
  value       = data.aws_cloudwatch_log_group.this.arn
}

output "creation_time" {
  description = "Creation time of the log group, expressed as the number of milliseconds after Jan 1, 1970 00:00:00 UTC."
  value       = data.aws_cloudwatch_log_group.this.creation_time
}

output "kms_key_id" {
  description = "ARN of the KMS Key to use when encrypting log data."
  value       = data.aws_cloudwatch_log_group.this.kms_key_id
}

output "log_group_class" {
  description = "The log class of the log group."
  value       = data.aws_cloudwatch_log_group.this.log_group_class
}

output "name" {
  description = "Name of the Cloudwatch log group"
  value       = data.aws_cloudwatch_log_group.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_cloudwatch_log_group.this.region
}

output "retention_in_days" {
  description = "Number of days log events retained in the specified log group."
  value       = data.aws_cloudwatch_log_group.this.retention_in_days
}

output "tags" {
  description = "Map of tags to assign to the resource."
  value       = data.aws_cloudwatch_log_group.this.tags
}