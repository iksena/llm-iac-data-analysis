output "delivery_options" {
  description = "An object that defines the dedicated IP pool that is used to send emails that you send using the configuration set."
  value       = data.aws_sesv2_configuration_set.this.delivery_options
}

output "reputation_options" {
  description = "An object that defines whether or not Amazon SES collects reputation metrics for the emails that you send that use the configuration set."
  value       = data.aws_sesv2_configuration_set.this.reputation_options
}

output "sending_options" {
  description = "An object that defines whether or not Amazon SES can send email that you send using the configuration set."
  value       = data.aws_sesv2_configuration_set.this.sending_options
}

output "suppression_options" {
  description = "An object that contains information about the suppression list preferences for your account."
  value       = data.aws_sesv2_configuration_set.this.suppression_options
}

output "tags" {
  description = "Key-value map of resource tags for the container recipe."
  value       = data.aws_sesv2_configuration_set.this.tags
}

output "tracking_options" {
  description = "An object that defines the open and click tracking options for emails that you send using the configuration set."
  value       = data.aws_sesv2_configuration_set.this.tracking_options
}

output "vdm_options" {
  description = "An object that contains information about the VDM preferences for your configuration set."
  value       = data.aws_sesv2_configuration_set.this.vdm_options
}