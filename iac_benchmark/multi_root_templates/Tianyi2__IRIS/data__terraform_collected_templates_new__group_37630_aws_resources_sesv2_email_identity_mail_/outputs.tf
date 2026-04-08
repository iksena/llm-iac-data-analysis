output "region" {
  description = "Region where this resource is managed."
  value       = aws_sesv2_email_identity_mail_from_attributes.this.region
}

output "email_identity" {
  description = "The verified email identity."
  value       = aws_sesv2_email_identity_mail_from_attributes.this.email_identity
}

output "behavior_on_mx_failure" {
  description = "The action to take if the required MX record isn't found when you send an email."
  value       = aws_sesv2_email_identity_mail_from_attributes.this.behavior_on_mx_failure
}

output "mail_from_domain" {
  description = "The custom MAIL FROM domain that the verified identity uses."
  value       = aws_sesv2_email_identity_mail_from_attributes.this.mail_from_domain
}