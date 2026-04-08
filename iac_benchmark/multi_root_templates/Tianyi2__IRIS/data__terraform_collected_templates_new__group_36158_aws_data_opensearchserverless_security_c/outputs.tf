output "id" {
  description = "The unique identifier of the security configuration."
  value       = data.aws_opensearchserverless_security_config.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_opensearchserverless_security_config.this.region
}

output "config_version" {
  description = "The version of the security configuration."
  value       = data.aws_opensearchserverless_security_config.this.config_version
}

output "created_date" {
  description = "The date the configuration was created."
  value       = data.aws_opensearchserverless_security_config.this.created_date
}

output "description" {
  description = "The description of the security configuration."
  value       = data.aws_opensearchserverless_security_config.this.description
}

output "last_modified_date" {
  description = "The date the configuration was last modified."
  value       = data.aws_opensearchserverless_security_config.this.last_modified_date
}

output "saml_options" {
  description = "SAML options for the security configuration."
  value       = data.aws_opensearchserverless_security_config.this.saml_options
}

output "type" {
  description = "The type of security configuration."
  value       = data.aws_opensearchserverless_security_config.this.type
}