output "application_integration_url" {
  description = "The URL to use in SDK integrations with managed rule groups."
  value       = aws_wafv2_web_acl.this.application_integration_url
}

output "arn" {
  description = "The ARN of the WAF WebACL."
  value       = aws_wafv2_web_acl.this.arn
}

output "capacity" {
  description = "Web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = aws_wafv2_web_acl.this.capacity
}

output "id" {
  description = "The ID of the WAF WebACL."
  value       = aws_wafv2_web_acl.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_wafv2_web_acl.this.tags_all
}