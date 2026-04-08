output "id" {
  description = "The ID of the WAF SQL Injection Match Set"
  value       = aws_waf_sql_injection_match_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the SQL injection match set"
  value       = aws_waf_sql_injection_match_set.this.arn
}