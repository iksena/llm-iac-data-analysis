output "id" {
  description = "The ID of the association"
  value       = aws_wafregional_web_acl_association.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_wafregional_web_acl_association.this.region
}

output "web_acl_id" {
  description = "The ID of the WAF Regional WebACL"
  value       = aws_wafregional_web_acl_association.this.web_acl_id
}

output "resource_arn" {
  description = "ARN of the associated resource"
  value       = aws_wafregional_web_acl_association.this.resource_arn
}