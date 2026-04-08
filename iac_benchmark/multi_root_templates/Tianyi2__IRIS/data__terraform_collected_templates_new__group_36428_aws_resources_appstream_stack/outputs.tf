output "arn" {
  description = "ARN of the appstream stack"
  value       = aws_appstream_stack.this.arn
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the stack was created"
  value       = aws_appstream_stack.this.created_time
}

output "id" {
  description = "Unique ID of the appstream stack"
  value       = aws_appstream_stack.this.id
}

output "name" {
  description = "Name of the AppStream stack"
  value       = aws_appstream_stack.this.name
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_appstream_stack.this.region
}

output "description" {
  description = "Description of the AppStream stack"
  value       = aws_appstream_stack.this.description
}

output "display_name" {
  description = "Display name of the AppStream stack"
  value       = aws_appstream_stack.this.display_name
}

output "embed_host_domains" {
  description = "Domains where AppStream 2.0 streaming sessions can be embedded"
  value       = aws_appstream_stack.this.embed_host_domains
}

output "feedback_url" {
  description = "URL that users are redirected to after they click the Send Feedback link"
  value       = aws_appstream_stack.this.feedback_url
}

output "redirect_url" {
  description = "URL that users are redirected to after their streaming session ends"
  value       = aws_appstream_stack.this.redirect_url
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = aws_appstream_stack.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags"
  value       = aws_appstream_stack.this.tags_all
}

output "access_endpoints" {
  description = "Set of configuration blocks defining the interface VPC endpoints"
  value       = aws_appstream_stack.this.access_endpoints
}

output "application_settings" {
  description = "Settings for application settings persistence"
  value       = aws_appstream_stack.this.application_settings
}

output "storage_connectors" {
  description = "Configuration block for the storage connectors"
  value       = aws_appstream_stack.this.storage_connectors
}

output "user_settings" {
  description = "Configuration block for user settings"
  value       = aws_appstream_stack.this.user_settings
}

output "streaming_experience_settings" {
  description = "Streaming protocol settings"
  value       = aws_appstream_stack.this.streaming_experience_settings
}