output "id" {
  description = "The ID of the Traffic Mirror target."
  value       = aws_ec2_traffic_mirror_target.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_traffic_mirror_target.this.tags_all
}

output "arn" {
  description = "The ARN of the traffic mirror target."
  value       = aws_ec2_traffic_mirror_target.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the traffic mirror target."
  value       = aws_ec2_traffic_mirror_target.this.owner_id
}