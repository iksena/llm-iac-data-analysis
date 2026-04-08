output "arn" {
  description = "The ARN of the custom plugin"
  value       = data.aws_mskconnect_custom_plugin.this.arn
}

output "description" {
  description = "A summary description of the custom plugin"
  value       = data.aws_mskconnect_custom_plugin.this.description
}

output "latest_revision" {
  description = "An ID of the latest successfully created revision of the custom plugin"
  value       = data.aws_mskconnect_custom_plugin.this.latest_revision
}

output "state" {
  description = "The state of the custom plugin"
  value       = data.aws_mskconnect_custom_plugin.this.state
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = data.aws_mskconnect_custom_plugin.this.tags
}