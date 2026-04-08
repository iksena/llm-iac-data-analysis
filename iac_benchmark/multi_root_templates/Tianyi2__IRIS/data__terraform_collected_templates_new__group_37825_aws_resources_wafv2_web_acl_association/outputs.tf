output "id" {
  description = "The ID of the WAFv2 Web ACL Association"
  value       = aws_wafv2_web_acl_association.this.id
}

output "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the resource associated with the web ACL"
  value       = aws_wafv2_web_acl_association.this.resource_arn
}

output "web_acl_arn" {
  description = "The Amazon Resource Name (ARN) of the Web ACL associated with the resource"
  value       = aws_wafv2_web_acl_association.this.web_acl_arn
}