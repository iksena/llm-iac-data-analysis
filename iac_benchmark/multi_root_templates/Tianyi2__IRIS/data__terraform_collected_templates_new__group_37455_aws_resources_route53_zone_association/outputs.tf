output "id" {
  description = "The calculated unique identifier for the association"
  value       = aws_route53_zone_association.this.id
}

output "owning_account" {
  description = "The account ID of the account that created the hosted zone"
  value       = aws_route53_zone_association.this.owning_account
}

output "zone_id" {
  description = "The private hosted zone to associate"
  value       = aws_route53_zone_association.this.zone_id
}

output "vpc_id" {
  description = "The VPC to associate with the private hosted zone"
  value       = aws_route53_zone_association.this.vpc_id
}

output "vpc_region" {
  description = "The VPC's region"
  value       = aws_route53_zone_association.this.vpc_region
}