output "arn" {
  description = "The Amazon Resource Name (ARN) of the Hosted Zone."
  value       = aws_route53_zone.this.arn
}

output "zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set. Find more about delegation sets in AWS docs."
  value       = aws_route53_zone.this.name_servers
}

output "primary_name_server" {
  description = "The Route 53 name server that created the SOA record."
  value       = aws_route53_zone.this.primary_name_server
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_zone.this.tags_all
}

output "name" {
  description = "The name of the hosted zone."
  value       = aws_route53_zone.this.name
}

output "comment" {
  description = "The comment for the hosted zone."
  value       = aws_route53_zone.this.comment
}

output "delegation_set_id" {
  description = "The ID of the reusable delegation set."
  value       = aws_route53_zone.this.delegation_set_id
}

output "force_destroy" {
  description = "Whether to destroy all records in the zone when destroying the zone."
  value       = aws_route53_zone.this.force_destroy
}

output "tags" {
  description = "A map of tags assigned to the zone."
  value       = aws_route53_zone.this.tags
}

output "vpc" {
  description = "Configuration block(s) specifying VPC(s) associated with the private hosted zone."
  value       = aws_route53_zone.this.vpc
}