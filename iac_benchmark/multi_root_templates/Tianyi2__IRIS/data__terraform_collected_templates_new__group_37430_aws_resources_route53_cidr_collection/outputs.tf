output "arn" {
  description = "The Amazon Resource Name (ARN) of the CIDR collection"
  value       = aws_route53_cidr_collection.this.arn
}

output "id" {
  description = "The CIDR collection ID"
  value       = aws_route53_cidr_collection.this.id
}

output "version" {
  description = "The latest version of the CIDR collection"
  value       = aws_route53_cidr_collection.this.version
}