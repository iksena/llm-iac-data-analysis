output "arn" {
  description = "The VPC origin ARN"
  value       = aws_cloudfront_vpc_origin.this.arn
}

output "etag" {
  description = "The current version of the origin"
  value       = aws_cloudfront_vpc_origin.this.etag
}

output "id" {
  description = "The VPC origin ID"
  value       = aws_cloudfront_vpc_origin.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudfront_vpc_origin.this.tags_all
}