output "id" {
  description = "The ID of the WAF Regex Match Set"
  value       = aws_waf_regex_match_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_waf_regex_match_set.this.arn
}