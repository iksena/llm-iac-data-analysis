output "id" {
  description = "The received license ARN (Same as: license_arn)."
  value       = data.aws_licensemanager_received_license.this.id
}

output "beneficiary" {
  description = "Granted license beneficiary. This is in the form of the ARN of the root user of the account."
  value       = data.aws_licensemanager_received_license.this.beneficiary
}

output "consumption_configuration" {
  description = "Configuration for consumption of the license."
  value       = data.aws_licensemanager_received_license.this.consumption_configuration
}

output "create_time" {
  description = "Creation time of the granted license in RFC 3339 format."
  value       = data.aws_licensemanager_received_license.this.create_time
}

output "entitlements" {
  description = "License entitlements."
  value       = data.aws_licensemanager_received_license.this.entitlements
}

output "home_region" {
  description = "Home Region of the granted license."
  value       = data.aws_licensemanager_received_license.this.home_region
}

output "issuer" {
  description = "Granted license issuer."
  value       = data.aws_licensemanager_received_license.this.issuer
}

output "license_arn" {
  description = "Amazon Resource Name (ARN) of the license."
  value       = data.aws_licensemanager_received_license.this.license_arn
}

output "license_metadata" {
  description = "Granted license metadata. This is in the form of a set of all meta data."
  value       = data.aws_licensemanager_received_license.this.license_metadata
}

output "license_name" {
  description = "License name."
  value       = data.aws_licensemanager_received_license.this.license_name
}

output "product_name" {
  description = "Product name."
  value       = data.aws_licensemanager_received_license.this.product_name
}

output "product_sku" {
  description = "Product SKU."
  value       = data.aws_licensemanager_received_license.this.product_sku
}

output "received_metadata" {
  description = "Granted license received metadata."
  value       = data.aws_licensemanager_received_license.this.received_metadata
}

output "status" {
  description = "Granted license status."
  value       = data.aws_licensemanager_received_license.this.status
}

output "validity" {
  description = "Date and time range during which the granted license is valid, in ISO8601-UTC format."
  value       = data.aws_licensemanager_received_license.this.validity
}

output "version" {
  description = "Version of the granted license."
  value       = data.aws_licensemanager_received_license.this.version
}