output "id" {
  description = "The Name of Domain"
  value       = aws_codeartifact_domain_permissions_policy.this.id
}

output "resource_arn" {
  description = "The ARN of the resource associated with the resource policy"
  value       = aws_codeartifact_domain_permissions_policy.this.resource_arn
}

output "domain" {
  description = "The name of the domain on which to set the resource policy"
  value       = aws_codeartifact_domain_permissions_policy.this.domain
}

output "policy_document" {
  description = "A JSON policy string to be set as the access control resource policy on the provided domain"
  value       = aws_codeartifact_domain_permissions_policy.this.policy_document
  sensitive   = true
}

output "domain_owner" {
  description = "The account number of the AWS account that owns the domain"
  value       = aws_codeartifact_domain_permissions_policy.this.domain_owner
}

output "policy_revision" {
  description = "The current revision of the resource policy to be set"
  value       = aws_codeartifact_domain_permissions_policy.this.policy_revision
}