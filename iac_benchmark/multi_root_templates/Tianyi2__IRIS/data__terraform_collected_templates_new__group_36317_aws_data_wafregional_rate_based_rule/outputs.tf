output "id" {
  description = "ID of the WAF Regional rate based rule"
  value       = data.aws_wafregional_rate_based_rule.this.id
}

output "name" {
  description = "Name of the WAF Regional rate based rule"
  value       = data.aws_wafregional_rate_based_rule.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_wafregional_rate_based_rule.this.region
}