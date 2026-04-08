output "id" {
  description = "The ID of the WAF ByteMatchSet."
  value       = aws_wafregional_byte_match_set.this.id
}