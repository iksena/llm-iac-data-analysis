output "id" {
  description = "A unique identifier for the IP set"
  value       = aws_wafv2_ip_set.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the IP set"
  value       = aws_wafv2_ip_set.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_wafv2_ip_set.this.tags_all
}