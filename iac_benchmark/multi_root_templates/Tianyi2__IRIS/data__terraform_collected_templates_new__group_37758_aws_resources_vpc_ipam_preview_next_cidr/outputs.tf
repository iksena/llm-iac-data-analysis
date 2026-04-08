output "cidr" {
  description = "The previewed CIDR from the pool"
  value       = aws_vpc_ipam_preview_next_cidr.this.cidr
}

output "id" {
  description = "The ID of the preview"
  value       = aws_vpc_ipam_preview_next_cidr.this.id
}

output "ipam_pool_id" {
  description = "The ID of the pool to which you want to assign a CIDR"
  value       = aws_vpc_ipam_preview_next_cidr.this.ipam_pool_id
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_vpc_ipam_preview_next_cidr.this.region
}

output "disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  value       = aws_vpc_ipam_preview_next_cidr.this.disallowed_cidrs
}

output "netmask_length" {
  description = "The netmask length of the CIDR you would like to preview from the IPAM pool"
  value       = aws_vpc_ipam_preview_next_cidr.this.netmask_length
}