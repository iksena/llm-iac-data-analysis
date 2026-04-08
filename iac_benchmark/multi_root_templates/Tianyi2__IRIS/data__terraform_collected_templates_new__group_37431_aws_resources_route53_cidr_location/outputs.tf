output "id" {
  description = "The ID of the CIDR collection concatenated with the name of the CIDR location"
  value       = aws_route53_cidr_location.this.id
}

output "cidr_blocks" {
  description = "CIDR blocks for the location"
  value       = aws_route53_cidr_location.this.cidr_blocks
}

output "cidr_collection_id" {
  description = "The ID of the CIDR collection to update"
  value       = aws_route53_cidr_location.this.cidr_collection_id
}

output "name" {
  description = "Name for the CIDR location"
  value       = aws_route53_cidr_location.this.name
}