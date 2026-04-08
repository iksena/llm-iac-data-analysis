output "id" {
  description = "The name of the domain the SAML options are associated with"
  value       = aws_elasticsearch_domain_saml_options.this.id
}

output "domain_name" {
  description = "Name of the domain"
  value       = aws_elasticsearch_domain_saml_options.this.domain_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_elasticsearch_domain_saml_options.this.region
}

output "saml_options" {
  description = "The SAML authentication options for the AWS Elasticsearch Domain"
  value       = aws_elasticsearch_domain_saml_options.this.saml_options
}