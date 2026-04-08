output "id" {
  description = "The ID of the environment."
  value       = aws_cloud9_environment_ec2.this.id
}

output "arn" {
  description = "The ARN of the environment."
  value       = aws_cloud9_environment_ec2.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloud9_environment_ec2.this.tags_all
}

output "type" {
  description = "The type of the environment (e.g., ssh or ec2)."
  value       = aws_cloud9_environment_ec2.this.type
}