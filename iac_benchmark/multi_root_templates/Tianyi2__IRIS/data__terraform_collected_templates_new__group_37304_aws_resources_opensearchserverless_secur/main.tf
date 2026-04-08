resource "aws_opensearchserverless_security_config" "this" {
  name        = var.name
  type        = var.type
  description = var.description
  region      = var.region

  saml_options {
    metadata        = var.saml_options.metadata
    group_attribute = var.saml_options.group_attribute
    session_timeout = var.saml_options.session_timeout
    user_attribute  = var.saml_options.user_attribute
  }
}