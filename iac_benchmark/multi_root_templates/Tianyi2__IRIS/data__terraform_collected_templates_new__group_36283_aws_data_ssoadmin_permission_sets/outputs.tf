output "arns" {
  description = "Set of string contain the ARN of all Permission Sets"
  value       = data.aws_ssoadmin_permission_sets.this.arns
}