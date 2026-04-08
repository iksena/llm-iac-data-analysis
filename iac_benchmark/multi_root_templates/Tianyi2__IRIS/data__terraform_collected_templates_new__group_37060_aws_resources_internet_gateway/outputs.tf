output "id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "arn" {
  description = "The ARN of the Internet Gateway"
  value       = aws_internet_gateway.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the internet gateway"
  value       = aws_internet_gateway.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_internet_gateway.this.tags_all
}