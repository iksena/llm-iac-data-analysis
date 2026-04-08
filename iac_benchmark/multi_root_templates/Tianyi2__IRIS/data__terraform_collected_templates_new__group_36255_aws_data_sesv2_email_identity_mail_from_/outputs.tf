output "email_identity" {
  description = "The name of the email identity."
  value       = data.aws_sesv2_email_identity_mail_from_attributes.this.email_identity
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_sesv2_email_identity_mail_from_attributes.this.region
}

output "behavior_on_mx_failure" {
  description = "The action to take if the required MX record isn't found when you send an email. Valid values: USE_DEFAULT_VALUE, REJECT_MESSAGE."
  value       = data.aws_sesv2_email_identity_mail_from_attributes.this.behavior_on_mx_failure
}

output "mail_from_domain" {
  description = "The custom MAIL FROM domain that you want the verified identity to use."
  value       = data.aws_sesv2_email_identity_mail_from_attributes.this.mail_from_domain
}