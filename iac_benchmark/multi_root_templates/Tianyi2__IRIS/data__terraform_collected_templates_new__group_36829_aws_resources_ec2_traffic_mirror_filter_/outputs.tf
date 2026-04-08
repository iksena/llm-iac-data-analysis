output "arn" {
  description = "ARN of the traffic mirror filter rule"
  value       = aws_ec2_traffic_mirror_filter_rule.this.arn
}

output "id" {
  description = "Name of the traffic mirror filter rule"
  value       = aws_ec2_traffic_mirror_filter_rule.this.id
}