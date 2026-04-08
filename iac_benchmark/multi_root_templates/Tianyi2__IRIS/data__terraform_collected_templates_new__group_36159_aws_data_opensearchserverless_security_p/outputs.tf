output "created_date" {
  description = "The date the security policy was created"
  value       = data.aws_opensearchserverless_security_policy.this.created_date
}

output "description" {
  description = "Description of the security policy"
  value       = data.aws_opensearchserverless_security_policy.this.description
}

output "last_modified_date" {
  description = "The date the security policy was last modified"
  value       = data.aws_opensearchserverless_security_policy.this.last_modified_date
}

output "policy" {
  description = "The JSON policy document without any whitespaces"
  value       = data.aws_opensearchserverless_security_policy.this.policy
}

output "policy_version" {
  description = "Version of the policy"
  value       = data.aws_opensearchserverless_security_policy.this.policy_version
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_opensearchserverless_security_policy.this.region
}

output "name" {
  description = "Name of the policy"
  value       = data.aws_opensearchserverless_security_policy.this.name
}

output "type" {
  description = "Type of security policy"
  value       = data.aws_opensearchserverless_security_policy.this.type
}