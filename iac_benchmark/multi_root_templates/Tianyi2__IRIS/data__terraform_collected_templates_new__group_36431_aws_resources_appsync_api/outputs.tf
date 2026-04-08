output "api_id" {
  description = "ID of the Event API."
  value       = aws_appsync_api.this.api_id
}

output "api_arn" {
  description = "ARN of the Event API."
  value       = aws_appsync_api.this.api_arn
}

output "dns" {
  description = "DNS configuration for the Event API."
  value       = aws_appsync_api.this.dns
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appsync_api.this.tags_all
}

output "waf_web_acl_arn" {
  description = "ARN of the associated WAF web ACL."
  value       = aws_appsync_api.this.waf_web_acl_arn
}