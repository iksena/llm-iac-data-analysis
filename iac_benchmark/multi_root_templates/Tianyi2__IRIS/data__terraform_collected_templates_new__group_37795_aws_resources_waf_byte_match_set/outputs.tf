output "id" {
  description = "The ID of the WAF Byte Match Set"
  value       = aws_waf_byte_match_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the byte match set"
  value       = aws_waf_byte_match_set.this.arn
}