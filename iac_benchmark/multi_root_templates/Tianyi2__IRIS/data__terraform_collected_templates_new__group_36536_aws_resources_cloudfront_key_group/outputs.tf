output "etag" {
  description = "The identifier for this version of the key group."
  value       = aws_cloudfront_key_group.this.etag
}

output "id" {
  description = "The identifier for the key group."
  value       = aws_cloudfront_key_group.this.id
}

output "comment" {
  description = "A comment to describe the key group."
  value       = aws_cloudfront_key_group.this.comment
}

output "items" {
  description = "A list of the identifiers of the public keys in the key group."
  value       = aws_cloudfront_key_group.this.items
}

output "name" {
  description = "A name to identify the key group."
  value       = aws_cloudfront_key_group.this.name
}