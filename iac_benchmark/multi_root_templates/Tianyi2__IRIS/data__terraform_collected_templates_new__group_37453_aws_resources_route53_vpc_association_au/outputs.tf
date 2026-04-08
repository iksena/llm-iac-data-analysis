output "id" {
  description = "The calculated unique identifier for the association"
  value       = aws_route53_vpc_association_authorization.this.id
}

output "zone_id" {
  description = "The ID of the private hosted zone"
  value       = aws_route53_vpc_association_authorization.this.zone_id
}

output "vpc_id" {
  description = "The VPC authorized for association"
  value       = aws_route53_vpc_association_authorization.this.vpc_id
}

output "vpc_region" {
  description = "The VPC's region"
  value       = aws_route53_vpc_association_authorization.this.vpc_region
}