output "id" {
  description = "ID of the WAF Regional Web ACL"
  value       = data.aws_wafregional_web_acl.this.id
}

output "name" {
  description = "Name of the WAF Regional Web ACL"
  value       = data.aws_wafregional_web_acl.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_wafregional_web_acl.this.region
}