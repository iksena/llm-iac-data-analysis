output "id" {
  description = "ID of the WAF Regional rule"
  value       = data.aws_wafregional_rule.this.id
}

output "name" {
  description = "Name of the WAF Regional rule"
  value       = data.aws_wafregional_rule.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_wafregional_rule.this.region
}