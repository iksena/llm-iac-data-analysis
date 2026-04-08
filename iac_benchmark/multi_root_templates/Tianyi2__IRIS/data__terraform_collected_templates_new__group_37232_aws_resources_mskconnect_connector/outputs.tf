output "arn" {
  description = "The Amazon Resource Name (ARN) of the connector"
  value       = aws_mskconnect_connector.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_mskconnect_connector.this.tags_all
}

output "version" {
  description = "The current version of the connector"
  value       = aws_mskconnect_connector.this.version
}