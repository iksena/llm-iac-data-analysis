output "id" {
  description = "The ID of the DHCP Options Set."
  value       = aws_vpc_dhcp_options.this.id
}

output "arn" {
  description = "The ARN of the DHCP Options Set."
  value       = aws_vpc_dhcp_options.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the DHCP options set."
  value       = aws_vpc_dhcp_options.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_dhcp_options.this.tags_all
}