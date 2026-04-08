output "arn" {
  description = "The ARN of the aggregator"
  value       = aws_config_configuration_aggregator.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_config_configuration_aggregator.this.tags_all
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_config_configuration_aggregator.this.region
}

output "name" {
  description = "The name of the configuration aggregator"
  value       = aws_config_configuration_aggregator.this.name
}

output "account_aggregation_source" {
  description = "The account(s) aggregation source configuration"
  value       = aws_config_configuration_aggregator.this.account_aggregation_source
}

output "organization_aggregation_source" {
  description = "The organization aggregation source configuration"
  value       = aws_config_configuration_aggregator.this.organization_aggregation_source
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_config_configuration_aggregator.this.tags
}