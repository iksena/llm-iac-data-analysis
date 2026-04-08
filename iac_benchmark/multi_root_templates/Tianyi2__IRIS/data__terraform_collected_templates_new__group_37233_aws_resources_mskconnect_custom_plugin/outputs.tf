output "arn" {
  description = "The Amazon Resource Name (ARN) of the custom plugin."
  value       = aws_mskconnect_custom_plugin.this.arn
}

output "latest_revision" {
  description = "An ID of the latest successfully created revision of the custom plugin."
  value       = aws_mskconnect_custom_plugin.this.latest_revision
}

output "state" {
  description = "The state of the custom plugin."
  value       = aws_mskconnect_custom_plugin.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_mskconnect_custom_plugin.this.tags_all
}