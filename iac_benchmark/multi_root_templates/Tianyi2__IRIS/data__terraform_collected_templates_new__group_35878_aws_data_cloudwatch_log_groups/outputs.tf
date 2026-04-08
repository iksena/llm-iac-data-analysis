output "arns" {
  description = "Set of ARNs of the Cloudwatch log groups"
  value       = data.aws_cloudwatch_log_groups.this.arns
}

output "log_group_names" {
  description = "Set of names of the Cloudwatch log groups"
  value       = data.aws_cloudwatch_log_groups.this.log_group_names
}