output "configuration" {
  description = "The configuration file."
  value       = data.aws_prometheus_default_scraper_configuration.this.configuration
}