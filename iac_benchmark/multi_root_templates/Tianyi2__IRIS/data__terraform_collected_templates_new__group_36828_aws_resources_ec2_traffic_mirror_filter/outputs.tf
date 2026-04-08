output "arn" {
  description = "The ARN of the traffic mirror filter."
  value       = aws_ec2_traffic_mirror_filter.this.arn
}

output "id" {
  description = "The name of the filter."
  value       = aws_ec2_traffic_mirror_filter.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_traffic_mirror_filter.this.tags_all
}