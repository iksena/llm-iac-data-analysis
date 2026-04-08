output "address" {
  description = "The DNS address of the endpoint."
  value       = aws_redshift_endpoint_access.this.address
}

output "id" {
  description = "The Redshift-managed VPC endpoint name."
  value       = aws_redshift_endpoint_access.this.id
}

output "port" {
  description = "The port number on which the cluster accepts incoming connections."
  value       = aws_redshift_endpoint_access.this.port
}

output "vpc_endpoint" {
  description = "The connection endpoint for connecting to an Amazon Redshift cluster through the proxy."
  value       = aws_redshift_endpoint_access.this.vpc_endpoint
}

output "vpc_endpoint_network_interface" {
  description = "One or more network interfaces of the endpoint. Also known as an interface endpoint."
  value       = aws_redshift_endpoint_access.this.vpc_endpoint[*].network_interface
}

output "vpc_endpoint_id" {
  description = "The connection endpoint ID for connecting an Amazon Redshift cluster through the proxy."
  value       = aws_redshift_endpoint_access.this.vpc_endpoint[*].vpc_endpoint_id
}

output "vpc_id" {
  description = "The VPC identifier that the endpoint is associated."
  value       = aws_redshift_endpoint_access.this.vpc_endpoint[*].vpc_id
}

output "network_interface_availability_zone" {
  description = "The Availability Zone."
  value       = flatten([for vpc_ep in aws_redshift_endpoint_access.this.vpc_endpoint : [for ni in vpc_ep.network_interface : ni.availability_zone]])
}

output "network_interface_id" {
  description = "The network interface identifier."
  value       = flatten([for vpc_ep in aws_redshift_endpoint_access.this.vpc_endpoint : [for ni in vpc_ep.network_interface : ni.network_interface_id]])
}

output "network_interface_private_ip_address" {
  description = "The IPv4 address of the network interface within the subnet."
  value       = flatten([for vpc_ep in aws_redshift_endpoint_access.this.vpc_endpoint : [for ni in vpc_ep.network_interface : ni.private_ip_address]])
}

output "network_interface_subnet_id" {
  description = "The subnet identifier."
  value       = flatten([for vpc_ep in aws_redshift_endpoint_access.this.vpc_endpoint : [for ni in vpc_ep.network_interface : ni.subnet_id]])
}