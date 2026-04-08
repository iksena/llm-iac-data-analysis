output "id" {
  description = "The ARN of the Group."
  value       = aws_xray_group.this.id
}

output "arn" {
  description = "The ARN of the Group."
  value       = aws_xray_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_xray_group.this.tags_all
}