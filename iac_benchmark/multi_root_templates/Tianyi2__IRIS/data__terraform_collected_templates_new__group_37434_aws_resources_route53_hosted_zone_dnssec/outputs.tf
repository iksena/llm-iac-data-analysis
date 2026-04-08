output "id" {
  description = "Route 53 Hosted Zone identifier"
  value       = aws_route53_hosted_zone_dnssec.this.id
}

output "hosted_zone_id" {
  description = "Identifier of the Route 53 Hosted Zone"
  value       = aws_route53_hosted_zone_dnssec.this.hosted_zone_id
}

output "signing_status" {
  description = "Hosted Zone signing status"
  value       = aws_route53_hosted_zone_dnssec.this.signing_status
}