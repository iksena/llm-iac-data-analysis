output "arn" {
  description = "Volume Amazon Resource Name (ARN), e.g., arn:aws:storagegateway:us-east-1:123456789012:tapepool/pool-12345678"
  value       = aws_storagegateway_tape_pool.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_storagegateway_tape_pool.this.tags_all
}