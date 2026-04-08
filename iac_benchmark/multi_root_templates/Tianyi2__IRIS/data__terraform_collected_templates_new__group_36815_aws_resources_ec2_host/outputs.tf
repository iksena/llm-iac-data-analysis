output "id" {
  description = "The ID of the allocated Dedicated Host. This is used to launch an instance onto a specific host."
  value       = aws_ec2_host.this.id
}

output "arn" {
  description = "The ARN of the Dedicated Host."
  value       = aws_ec2_host.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the Dedicated Host."
  value       = aws_ec2_host.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_host.this.tags_all
}