output "id" {
  description = "The ID of the WAF SqlInjectionMatchSet."
  value       = aws_wafregional_sql_injection_match_set.this.id
}