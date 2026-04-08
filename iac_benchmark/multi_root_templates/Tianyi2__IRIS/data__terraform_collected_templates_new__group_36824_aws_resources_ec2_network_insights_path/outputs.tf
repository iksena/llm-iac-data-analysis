output "arn" {
  description = "ARN of the Network Insights Path."
  value       = aws_ec2_network_insights_path.this.arn
}

output "destination_arn" {
  description = "ARN of the destination."
  value       = aws_ec2_network_insights_path.this.destination_arn
}

output "id" {
  description = "ID of the Network Insights Path."
  value       = aws_ec2_network_insights_path.this.id
}

output "source_arn" {
  description = "ARN of the source."
  value       = aws_ec2_network_insights_path.this.source_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_network_insights_path.this.tags_all
}