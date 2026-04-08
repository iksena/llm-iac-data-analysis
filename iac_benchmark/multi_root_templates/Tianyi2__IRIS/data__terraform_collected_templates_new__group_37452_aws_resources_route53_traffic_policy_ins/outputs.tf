output "arn" {
  description = "Amazon Resource Name (ARN) of the traffic policy instance."
  value       = aws_route53_traffic_policy_instance.this.arn
}

output "id" {
  description = "ID of traffic policy instance."
  value       = aws_route53_traffic_policy_instance.this.id
}