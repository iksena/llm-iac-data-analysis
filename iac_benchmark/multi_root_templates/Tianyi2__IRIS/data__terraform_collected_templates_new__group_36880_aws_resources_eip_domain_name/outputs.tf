output "ptr_record" {
  description = "The DNS pointer (PTR) record for the IP address."
  value       = aws_eip_domain_name.this.ptr_record
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_eip_domain_name.this.region
}

output "allocation_id" {
  description = "The allocation ID."
  value       = aws_eip_domain_name.this.allocation_id
}

output "domain_name" {
  description = "The domain name to modify for the IP address."
  value       = aws_eip_domain_name.this.domain_name
}