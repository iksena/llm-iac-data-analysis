output "id" {
  description = "The ID of the WAF WebACL"
  value       = aws_waf_web_acl.this.id
}

output "arn" {
  description = "The ARN of the WAF WebACL"
  value       = aws_waf_web_acl.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_waf_web_acl.this.tags_all
}