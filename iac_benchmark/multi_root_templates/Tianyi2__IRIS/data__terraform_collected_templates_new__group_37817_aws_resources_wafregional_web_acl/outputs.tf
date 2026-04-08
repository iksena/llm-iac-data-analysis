output "arn" {
  description = "Amazon Resource Name (ARN) of the WAF Regional WebACL."
  value       = aws_wafregional_web_acl.this.arn
}

output "id" {
  description = "The ID of the WAF Regional WebACL."
  value       = aws_wafregional_web_acl.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_wafregional_web_acl.this.tags_all
}