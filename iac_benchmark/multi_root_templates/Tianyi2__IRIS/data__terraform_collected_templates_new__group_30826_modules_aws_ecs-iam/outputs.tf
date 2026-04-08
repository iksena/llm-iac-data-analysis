output "iam_instance_profile" {
  value = aws_iam_instance_profile.ecs-service-role.name
}