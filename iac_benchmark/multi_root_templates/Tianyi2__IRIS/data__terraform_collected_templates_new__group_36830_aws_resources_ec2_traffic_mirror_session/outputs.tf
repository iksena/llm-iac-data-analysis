output "arn" {
  description = "The ARN of the traffic mirror session."
  value       = aws_ec2_traffic_mirror_session.this.arn
}

output "id" {
  description = "The name of the session."
  value       = aws_ec2_traffic_mirror_session.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_traffic_mirror_session.this.tags_all
}

output "owner_id" {
  description = "The AWS account ID of the session owner."
  value       = aws_ec2_traffic_mirror_session.this.owner_id
}