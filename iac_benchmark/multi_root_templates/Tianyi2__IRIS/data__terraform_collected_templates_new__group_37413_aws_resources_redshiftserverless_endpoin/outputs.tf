output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Endpoint Access"
  value       = aws_redshiftserverless_endpoint_access.this.arn
}

output "id" {
  description = "The Redshift Endpoint Access Name"
  value       = aws_redshiftserverless_endpoint_access.this.id
}

output "address" {
  description = "The DNS address of the VPC endpoint"
  value       = aws_redshiftserverless_endpoint_access.this.address
}

output "port" {
  description = "The port that Amazon Redshift Serverless listens on"
  value       = aws_redshiftserverless_endpoint_access.this.port
}

output "vpc_endpoint" {
  description = "The VPC endpoint or the Redshift Serverless workgroup"
  value       = aws_redshiftserverless_endpoint_access.this.vpc_endpoint
}

output "vpc_endpoint_id" {
  description = "The DNS address of the VPC endpoint"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].vpc_endpoint_id, null)
}

output "vpc_id" {
  description = "The port that Amazon Redshift Serverless listens on"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].vpc_id, null)
}

output "network_interface" {
  description = "The network interfaces of the endpoint"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].network_interface, [])
}

output "availability_zone" {
  description = "The availability Zone"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].network_interface[0].availability_zone, null)
}

output "network_interface_id" {
  description = "The unique identifier of the network interface"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].network_interface[0].network_interface_id, null)
}

output "private_ip_address" {
  description = "The IPv4 address of the network interface within the subnet"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].network_interface[0].private_ip_address, null)
}

output "subnet_id" {
  description = "The unique identifier of the subnet"
  value       = try(aws_redshiftserverless_endpoint_access.this.vpc_endpoint[0].network_interface[0].subnet_id, null)
}