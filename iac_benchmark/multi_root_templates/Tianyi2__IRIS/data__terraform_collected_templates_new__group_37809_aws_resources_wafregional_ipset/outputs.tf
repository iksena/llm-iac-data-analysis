output "id" {
  description = "The ID of the WAF IPSet."
  value       = aws_wafregional_ipset.this.id
}

output "arn" {
  description = "The ARN of the WAF IPSet."
  value       = aws_wafregional_ipset.this.arn
}