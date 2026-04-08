output "id" {
  description = "The ID of the WAF XssMatchSet"
  value       = aws_waf_xss_match_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_waf_xss_match_set.this.arn
}