output "alarm_arns" {
  description = "List of CloudWatch alarm ARNs associated with the scaling policy."
  value       = aws_appautoscaling_policy.this.alarm_arns
}

output "arn" {
  description = "ARN assigned by AWS to the scaling policy."
  value       = aws_appautoscaling_policy.this.arn
}

output "name" {
  description = "Scaling policy's name."
  value       = aws_appautoscaling_policy.this.name
}

output "policy_type" {
  description = "Scaling policy's type."
  value       = aws_appautoscaling_policy.this.policy_type
}