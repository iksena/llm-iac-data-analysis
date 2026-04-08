output "id" {
  description = "The domain_name and service_arn separated by a comma (,)."
  value       = aws_apprunner_custom_domain_association.this.id
}

output "certificate_validation_records" {
  description = "A set of certificate CNAME records used for this domain name."
  value       = aws_apprunner_custom_domain_association.this.certificate_validation_records
}

output "dns_target" {
  description = "App Runner subdomain of the App Runner service. The custom domain name is mapped to this target name. Attribute only available if resource created (not imported) with Terraform."
  value       = aws_apprunner_custom_domain_association.this.dns_target
}