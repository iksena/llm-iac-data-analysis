output "id" {
  description = "Amazon Resource Name (ARN) of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl_logging_configuration.this.id
}