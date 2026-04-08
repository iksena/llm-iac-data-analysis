output "name" {
  description = "Name of the policy."
  value       = aws_opensearchserverless_security_config.this.name
}

output "type" {
  description = "Type of configuration."
  value       = aws_opensearchserverless_security_config.this.type
}

output "description" {
  description = "Description of the security configuration."
  value       = aws_opensearchserverless_security_config.this.description
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_opensearchserverless_security_config.this.region
}

output "config_version" {
  description = "Version of the configuration."
  value       = aws_opensearchserverless_security_config.this.config_version
}

output "saml_options" {
  description = "Configuration block for SAML options."
  value = {
    metadata        = aws_opensearchserverless_security_config.this.saml_options[0].metadata
    group_attribute = aws_opensearchserverless_security_config.this.saml_options[0].group_attribute
    session_timeout = aws_opensearchserverless_security_config.this.saml_options[0].session_timeout
    user_attribute  = aws_opensearchserverless_security_config.this.saml_options[0].user_attribute
  }
}