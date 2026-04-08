output "cidr" {
  description = "Previewed CIDR from the pool"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.cidr
}

output "id" {
  description = "ID of the preview"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.id
}

output "ipam_pool_id" {
  description = "ID of the pool to which you want to assign a CIDR"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.ipam_pool_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.region
}

output "disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.disallowed_cidrs
}

output "netmask_length" {
  description = "Netmask length of the CIDR you would like to preview from the IPAM pool"
  value       = data.aws_vpc_ipam_preview_next_cidr.this.netmask_length
}