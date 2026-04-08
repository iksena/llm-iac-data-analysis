output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the server certificate"
  value       = aws_iam_server_certificate.this.arn
}

output "expiration" {
  description = "Date and time in RFC3339 format on which the certificate is set to expire"
  value       = aws_iam_server_certificate.this.expiration
}

output "id" {
  description = "The unique Server Certificate name"
  value       = aws_iam_server_certificate.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iam_server_certificate.this.tags_all
}

output "upload_date" {
  description = "Date and time in RFC3339 format when the server certificate was uploaded"
  value       = aws_iam_server_certificate.this.upload_date
}