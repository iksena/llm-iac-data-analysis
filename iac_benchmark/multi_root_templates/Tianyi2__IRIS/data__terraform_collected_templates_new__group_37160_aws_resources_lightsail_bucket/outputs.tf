output "arn" {
  description = "ARN of the Lightsail bucket"
  value       = aws_lightsail_bucket.this.arn
}

output "availability_zone" {
  description = "Availability Zone. Follows the format us-east-2a (case-sensitive)"
  value       = aws_lightsail_bucket.this.availability_zone
}

output "created_at" {
  description = "Date and time when the bucket was created"
  value       = aws_lightsail_bucket.this.created_at
}

output "id" {
  description = "Name used for this bucket (matches name)"
  value       = aws_lightsail_bucket.this.id
}

output "support_code" {
  description = "Support code for the resource. Include this code in your email to support when you have questions about a resource in Lightsail"
  value       = aws_lightsail_bucket.this.support_code
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lightsail_bucket.this.tags_all
}

output "url" {
  description = "URL of the bucket"
  value       = aws_lightsail_bucket.this.url
}