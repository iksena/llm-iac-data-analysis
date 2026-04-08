output "arn" {
  description = "ARN of the lightsail certificate."
  value       = aws_lightsail_lb_certificate.this.arn
}

output "created_at" {
  description = "Timestamp when the instance was created."
  value       = aws_lightsail_lb_certificate.this.created_at
}

output "domain_validation_records" {
  description = "Set of domain validation objects which can be used to complete certificate validation. Can have more than one element, e.g., if SANs are defined."
  value       = aws_lightsail_lb_certificate.this.domain_validation_records
}

output "id" {
  description = "Combination of attributes to create a unique id: lb_name,name"
  value       = aws_lightsail_lb_certificate.this.id
}

output "support_code" {
  description = "Support code for the certificate."
  value       = aws_lightsail_lb_certificate.this.support_code
}