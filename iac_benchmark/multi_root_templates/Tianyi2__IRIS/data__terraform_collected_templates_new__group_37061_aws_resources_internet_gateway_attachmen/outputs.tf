output "id" {
  description = "The ID of the VPC and Internet Gateway separated by a colon."
  value       = aws_internet_gateway_attachment.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_internet_gateway_attachment.this.region
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway."
  value       = aws_internet_gateway_attachment.this.internet_gateway_id
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_internet_gateway_attachment.this.vpc_id
}