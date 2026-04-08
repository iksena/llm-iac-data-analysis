output "availability_zone" {
  description = "The Availability Zone of the subnet"
  value       = aws_default_subnet.this.availability_zone
}

output "availability_zone_id" {
  description = "The AZ ID of the subnet"
  value       = aws_default_subnet.this.availability_zone_id
}

output "cidr_block" {
  description = "The IPv4 CIDR block assigned to the subnet"
  value       = aws_default_subnet.this.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC the subnet is in"
  value       = aws_default_subnet.this.vpc_id
}

output "id" {
  description = "The ID of the subnet"
  value       = aws_default_subnet.this.id
}

output "arn" {
  description = "The ARN of the subnet"
  value       = aws_default_subnet.this.arn
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_default_subnet.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_default_subnet.this.tags_all
}