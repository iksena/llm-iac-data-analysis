output "certificate_id" {
  description = "The ID for the signing certificate"
  value       = aws_iam_signing_certificate.this.certificate_id
}

output "id" {
  description = "The certificate_id:user_name"
  value       = aws_iam_signing_certificate.this.id
}

output "certificate_body" {
  description = "The contents of the signing certificate in PEM-encoded format"
  value       = aws_iam_signing_certificate.this.certificate_body
  sensitive   = true
}

output "status" {
  description = "The status assigned to the certificate"
  value       = aws_iam_signing_certificate.this.status
}

output "user_name" {
  description = "The name of the user the signing certificate is for"
  value       = aws_iam_signing_certificate.this.user_name
}