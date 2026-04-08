output "arn" {
  description = "ARN of the Media Insights Pipeline Configuration"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.arn
}

output "id" {
  description = "Unique ID of the Media Insights Pipeline Configuration"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.id
}

output "name" {
  description = "Configuration name"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.name
}

output "resource_access_role_arn" {
  description = "ARN of IAM Role used by service to invoke processors and sinks specified by configuration elements"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.resource_access_role_arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.region
}

output "elements" {
  description = "Collection of processors and sinks to transform media and deliver data"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.elements
}

output "real_time_alert_configuration" {
  description = "Configuration for real-time alert rules to send EventBridge notifications when certain conditions are met"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.real_time_alert_configuration
}

output "tags" {
  description = "Key-value map of tags for the resource"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.this.tags_all
}