output "id" {
  description = "The ID of the WAF Regex Pattern Set"
  value       = aws_waf_regex_pattern_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_waf_regex_pattern_set.this.arn
}