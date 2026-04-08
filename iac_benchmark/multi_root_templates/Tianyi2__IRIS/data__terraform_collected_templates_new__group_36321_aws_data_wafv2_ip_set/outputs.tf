output "addresses" {
  description = "An array of strings that specifies zero or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation."
  value       = data.aws_wafv2_ip_set.this.addresses
}

output "arn" {
  description = "ARN of the entity."
  value       = data.aws_wafv2_ip_set.this.arn
}

output "description" {
  description = "Description of the set that helps with identification."
  value       = data.aws_wafv2_ip_set.this.description
}

output "id" {
  description = "Unique identifier for the set."
  value       = data.aws_wafv2_ip_set.this.id
}

output "ip_address_version" {
  description = "IP address version of the set."
  value       = data.aws_wafv2_ip_set.this.ip_address_version
}