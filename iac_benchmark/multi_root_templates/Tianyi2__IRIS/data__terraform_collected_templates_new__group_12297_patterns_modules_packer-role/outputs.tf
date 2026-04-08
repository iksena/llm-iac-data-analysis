output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.packer_role.arn
}

output "instance_profile_name" {
  description = "Name of the created IAM instance profile"
  value       = aws_iam_instance_profile.packer_profile.name
}
