output "id" {
  description = "The directory identifier"
  value       = aws_directory_service_radius_settings.this.id
}

output "authentication_protocol" {
  description = "The protocol specified for your RADIUS endpoints"
  value       = aws_directory_service_radius_settings.this.authentication_protocol
}

output "directory_id" {
  description = "The identifier of the directory for which you want to manager RADIUS settings"
  value       = aws_directory_service_radius_settings.this.directory_id
}

output "display_label" {
  description = "Display label"
  value       = aws_directory_service_radius_settings.this.display_label
}

output "radius_port" {
  description = "The port that your RADIUS server is using for communications"
  value       = aws_directory_service_radius_settings.this.radius_port
}

output "radius_retries" {
  description = "The maximum number of times that communication with the RADIUS server is attempted"
  value       = aws_directory_service_radius_settings.this.radius_retries
}

output "radius_servers" {
  description = "An array of strings that contains the fully qualified domain name (FQDN) or IP addresses of the RADIUS server endpoints"
  value       = aws_directory_service_radius_settings.this.radius_servers
}

output "radius_timeout" {
  description = "The amount of time, in seconds, to wait for the RADIUS server to respond"
  value       = aws_directory_service_radius_settings.this.radius_timeout
}

output "shared_secret" {
  description = "Required for enabling RADIUS on the directory"
  value       = aws_directory_service_radius_settings.this.shared_secret
  sensitive   = true
}

output "use_same_username" {
  description = "Not currently used"
  value       = aws_directory_service_radius_settings.this.use_same_username
}