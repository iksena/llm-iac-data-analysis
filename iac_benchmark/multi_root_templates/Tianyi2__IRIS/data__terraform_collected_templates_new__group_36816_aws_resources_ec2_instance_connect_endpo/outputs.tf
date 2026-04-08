output "arn" {
  description = "The Amazon Resource Name (ARN) of the EC2 Instance Connect Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.arn
}

output "availability_zone" {
  description = "The Availability Zone of the EC2 Instance Connect Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.availability_zone
}

output "dns_name" {
  description = "The DNS name of the EC2 Instance Connect Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.dns_name
}

output "fips_dns_name" {
  description = "The DNS name of the EC2 Instance Connect FIPS Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.fips_dns_name
}

output "network_interface_ids" {
  description = "The IDs of the ENIs that Amazon EC2 automatically created when creating the EC2 Instance Connect Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.network_interface_ids
}

output "owner_id" {
  description = "The ID of the AWS account that created the EC2 Instance Connect Endpoint."
  value       = aws_ec2_instance_connect_endpoint.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_instance_connect_endpoint.this.tags_all
}

output "vpc_id" {
  description = "The ID of the VPC in which the EC2 Instance Connect Endpoint was created."
  value       = aws_ec2_instance_connect_endpoint.this.vpc_id
}