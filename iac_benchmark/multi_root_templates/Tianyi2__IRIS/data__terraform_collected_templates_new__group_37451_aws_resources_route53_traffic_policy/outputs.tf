output "arn" {
  description = "Amazon Resource Name (ARN) of the traffic policy"
  value       = aws_route53_traffic_policy.this.arn
}

output "id" {
  description = "ID of the traffic policy"
  value       = aws_route53_traffic_policy.this.id
}

output "type" {
  description = "DNS type of the resource record sets that Amazon Route 53 creates when you use a traffic policy to create a traffic policy instance"
  value       = aws_route53_traffic_policy.this.type
}

output "version" {
  description = "Version number of the traffic policy. This value is automatically incremented by AWS after each update of this resource"
  value       = aws_route53_traffic_policy.this.version
}