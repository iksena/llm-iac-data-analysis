output "arn" {
  description = "The ARN of the attachment"
  value       = aws_networkmonitor_probe.this.arn
}

output "source_arn" {
  description = "The ARN of the subnet"
  value       = aws_networkmonitor_probe.this.source_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmonitor_probe.this.tags_all
}