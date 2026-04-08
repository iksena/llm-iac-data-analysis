output "arn" {
  description = "ARN of the Hosted Zone"
  value       = data.aws_route53_zone.this.arn
}

output "caller_reference" {
  description = "Caller Reference of the Hosted Zone"
  value       = data.aws_route53_zone.this.caller_reference
}

output "comment" {
  description = "Comment field of the Hosted Zone"
  value       = data.aws_route53_zone.this.comment
}

output "linked_service_principal" {
  description = "The service that created the Hosted Zone"
  value       = data.aws_route53_zone.this.linked_service_principal
}

output "linked_service_description" {
  description = "The description provided by the service that created the Hosted Zone"
  value       = data.aws_route53_zone.this.linked_service_description
}

output "name" {
  description = "The Hosted Zone name"
  value       = data.aws_route53_zone.this.name
}

output "name_servers" {
  description = "List of DNS name servers for the Hosted Zone"
  value       = data.aws_route53_zone.this.name_servers
}

output "primary_name_server" {
  description = "The Route 53 name server that created the SOA record"
  value       = data.aws_route53_zone.this.primary_name_server
}

output "private_zone" {
  description = "Indicates whether this is a private hosted zone"
  value       = data.aws_route53_zone.this.private_zone
}

output "resource_record_set_count" {
  description = "The number of Record Set in the Hosted Zone"
  value       = data.aws_route53_zone.this.resource_record_set_count
}

output "tags" {
  description = "A map of tags assigned to the Hosted Zone"
  value       = data.aws_route53_zone.this.tags
}

output "zone_id" {
  description = "The Hosted Zone identifier"
  value       = data.aws_route53_zone.this.zone_id
}