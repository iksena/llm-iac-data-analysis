output "arn" {
  description = "ARN of the Group"
  value       = aws_synthetics_group.this.arn
}

output "group_id" {
  description = "ID of the Group"
  value       = aws_synthetics_group.this.group_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_synthetics_group.this.tags_all
}