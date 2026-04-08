output "arn" {
  description = "ARN of the found certificate, suitable for referencing in other resources that support ACM certificates."
  value       = data.aws_acm_certificate.this.arn
}

output "id" {
  description = "ARN of the found certificate, suitable for referencing in other resources that support ACM certificates."
  value       = data.aws_acm_certificate.this.id
}

output "status" {
  description = "Status of the found certificate."
  value       = data.aws_acm_certificate.this.status
}

output "certificate" {
  description = "ACM-issued certificate."
  value       = data.aws_acm_certificate.this.certificate
}

output "certificate_chain" {
  description = "Certificates forming the requested ACM-issued certificate's chain of trust. The chain consists of the certificate of the issuing CA and the intermediate certificates of any other subordinate CAs."
  value       = data.aws_acm_certificate.this.certificate_chain
}

output "tags" {
  description = "Mapping of tags for the resource."
  value       = data.aws_acm_certificate.this.tags
}