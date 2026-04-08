output "id" {
  description = "ID of the managed prefix list entry."
  value       = aws_ec2_managed_prefix_list_entry.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ec2_managed_prefix_list_entry.this.region
}

output "cidr" {
  description = "CIDR block of this entry."
  value       = aws_ec2_managed_prefix_list_entry.this.cidr
}

output "description" {
  description = "Description of this entry."
  value       = aws_ec2_managed_prefix_list_entry.this.description
}

output "prefix_list_id" {
  description = "The ID of the prefix list."
  value       = aws_ec2_managed_prefix_list_entry.this.prefix_list_id
}