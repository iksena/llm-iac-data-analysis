output "id" {
  description = "AWS region."
  value       = data.aws_ssoadmin_application_providers.this.id
}

output "application_providers" {
  description = "A list of application providers available in the current region."
  value       = data.aws_ssoadmin_application_providers.this.application_providers
}

output "application_provider_arns" {
  description = "List of ARNs of the application providers."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.application_provider_arn]
}

output "display_data" {
  description = "List of display data objects describing how IAM Identity Center represents each application provider in the portal."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.display_data]
}

output "federation_protocols" {
  description = "List of protocols that each application provider uses to perform federation."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.federation_protocol]
}

output "descriptions" {
  description = "List of descriptions of the application providers."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.display_data.description]
}

output "display_names" {
  description = "List of names of the application providers."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.display_data.display_name]
}

output "icon_urls" {
  description = "List of URLs that point to icons that represent the application providers."
  value       = [for provider in data.aws_ssoadmin_application_providers.this.application_providers : provider.display_data.icon_url]
}