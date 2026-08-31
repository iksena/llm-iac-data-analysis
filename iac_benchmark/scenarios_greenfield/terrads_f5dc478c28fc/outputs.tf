output "instance_profile_arn" {
  value = aws_iam_instance_profile.instance_profile.arn
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.instance_profile.id
}

output "role_arn" {
  value = aws_iam_role.role.arn
}

output "role_id" {
  value = aws_iam_role.role.id
}
