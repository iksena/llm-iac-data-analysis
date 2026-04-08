output "name" {
  description = "The name of the retention configuration object. The object is always named 'default'."
  value       = aws_config_retention_configuration.this.name
}