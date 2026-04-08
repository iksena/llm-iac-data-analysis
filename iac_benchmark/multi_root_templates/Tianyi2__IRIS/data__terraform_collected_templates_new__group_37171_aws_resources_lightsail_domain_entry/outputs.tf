output "id" {
  description = "Combination of attributes to create a unique id: name,domain_name,type,target"
  value       = aws_lightsail_domain_entry.this.id
}

output "domain_name" {
  description = "Name of the Lightsail domain in which to create the entry"
  value       = aws_lightsail_domain_entry.this.domain_name
}

output "name" {
  description = "Name of the entry record"
  value       = aws_lightsail_domain_entry.this.name
}

output "target" {
  description = "Target of the domain entry"
  value       = aws_lightsail_domain_entry.this.target
}

output "type" {
  description = "Type of record"
  value       = aws_lightsail_domain_entry.this.type
}

output "is_alias" {
  description = "Whether the entry should be an alias"
  value       = aws_lightsail_domain_entry.this.is_alias
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_lightsail_domain_entry.this.region
}