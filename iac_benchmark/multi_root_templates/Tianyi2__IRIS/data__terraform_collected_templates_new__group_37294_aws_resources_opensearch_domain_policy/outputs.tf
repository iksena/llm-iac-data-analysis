output "id" {
  description = "The domain name"
  value       = aws_opensearch_domain_policy.this.id
}

output "domain_name" {
  description = "The domain name"
  value       = aws_opensearch_domain_policy.this.domain_name
}

output "access_policies" {
  description = "The access policies for the domain"
  value       = aws_opensearch_domain_policy.this.access_policies
}