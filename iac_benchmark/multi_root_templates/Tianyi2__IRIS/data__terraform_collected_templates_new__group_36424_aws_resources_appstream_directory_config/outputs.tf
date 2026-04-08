output "id" {
  description = "Unique identifier (ID) of the appstream directory config"
  value       = aws_appstream_directory_config.this.id
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the directory config was created"
  value       = aws_appstream_directory_config.this.created_time
}