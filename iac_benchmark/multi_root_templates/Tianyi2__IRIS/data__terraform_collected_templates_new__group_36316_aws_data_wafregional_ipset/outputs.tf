output "id" {
  description = "ID of the WAF Regional IP set"
  value       = data.aws_wafregional_ipset.this.id
}

output "name" {
  description = "Name of the WAF Regional IP set"
  value       = data.aws_wafregional_ipset.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_wafregional_ipset.this.region
}