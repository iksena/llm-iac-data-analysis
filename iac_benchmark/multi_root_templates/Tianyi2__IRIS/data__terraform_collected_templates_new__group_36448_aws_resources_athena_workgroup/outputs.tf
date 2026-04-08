output "arn" {
  description = "ARN of the workgroup"
  value       = aws_athena_workgroup.this.arn
}

output "id" {
  description = "Workgroup name"
  value       = aws_athena_workgroup.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_athena_workgroup.this.tags_all
}

output "configuration" {
  description = "Configuration block with various settings for the workgroup"
  value       = aws_athena_workgroup.this.configuration
}

output "effective_engine_version" {
  description = "The engine version on which the query runs. If selected_engine_version is set to AUTO, the effective engine version is chosen by Athena"
  value       = length(aws_athena_workgroup.this.configuration) > 0 && length(aws_athena_workgroup.this.configuration[0].engine_version) > 0 ? aws_athena_workgroup.this.configuration[0].engine_version[0].effective_engine_version : null
}