output "arn" {
  description = "The ARN assigned by AWS for this provider."
  value       = aws_iam_saml_provider.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iam_saml_provider.this.tags_all
}

output "valid_until" {
  description = "The expiration date and time for the SAML provider in RFC1123 format."
  value       = aws_iam_saml_provider.this.valid_until
}