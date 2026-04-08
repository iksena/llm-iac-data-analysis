output "api_key" {
  description = "The generated API key. This value is sensitive."
  value       = aws_wafv2_api_key.this.api_key
  sensitive   = true
}