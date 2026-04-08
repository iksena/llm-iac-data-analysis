output "id" {
  description = "The ID of the WAF IPSet"
  value       = aws_waf_ipset.this.id
}

output "arn" {
  description = "The ARN of the WAF IPSet"
  value       = aws_waf_ipset.this.arn
}