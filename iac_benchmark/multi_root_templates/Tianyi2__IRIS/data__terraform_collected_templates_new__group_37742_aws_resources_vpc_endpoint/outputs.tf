output "id" {
  description = "The ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint."
  value       = aws_vpc_endpoint.this.arn
}

output "cidr_blocks" {
  description = "The list of CIDR blocks for the exposed AWS service. Applicable for endpoints of type Gateway."
  value       = aws_vpc_endpoint.this.cidr_blocks
}

output "dns_entry" {
  description = "The DNS entries for the VPC Endpoint. Applicable for endpoints of type Interface. DNS blocks contain dns_name and hosted_zone_id attributes."
  value       = aws_vpc_endpoint.this.dns_entry
}

output "network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type Interface."
  value       = aws_vpc_endpoint.this.network_interface_ids
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC endpoint."
  value       = aws_vpc_endpoint.this.owner_id
}

output "prefix_list_id" {
  description = "The prefix list ID of the exposed AWS service. Applicable for endpoints of type Gateway."
  value       = aws_vpc_endpoint.this.prefix_list_id
}

output "requester_managed" {
  description = "Whether or not the VPC Endpoint is being managed by its service - true or false."
  value       = aws_vpc_endpoint.this.requester_managed
}

output "state" {
  description = "The state of the VPC endpoint."
  value       = aws_vpc_endpoint.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_endpoint.this.tags_all
}