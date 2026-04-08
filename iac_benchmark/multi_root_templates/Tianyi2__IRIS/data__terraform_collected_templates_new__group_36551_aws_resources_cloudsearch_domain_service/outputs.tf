output "id" {
  description = "The domain name of the CloudSearch domain."
  value       = aws_cloudsearch_domain_service_access_policy.this.id
}

output "access_policy" {
  description = "The access policy applied to the CloudSearch domain."
  value       = aws_cloudsearch_domain_service_access_policy.this.access_policy
}

output "domain_name" {
  description = "The CloudSearch domain name the policy applies to."
  value       = aws_cloudsearch_domain_service_access_policy.this.domain_name
}

output "region" {
  description = "The region where the resource is managed."
  value       = aws_cloudsearch_domain_service_access_policy.this.region
}