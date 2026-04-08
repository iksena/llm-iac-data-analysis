output "name" {
  description = "Name of the policy"
  value       = data.aws_opensearchserverless_access_policy.this.name
}

output "type" {
  description = "Type of access policy"
  value       = data.aws_opensearchserverless_access_policy.this.type
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_opensearchserverless_access_policy.this.region
}

output "description" {
  description = "Description of the policy"
  value       = data.aws_opensearchserverless_access_policy.this.description
}

output "policy" {
  description = "JSON policy document"
  value       = data.aws_opensearchserverless_access_policy.this.policy
}

output "policy_version" {
  description = "Version of the policy"
  value       = data.aws_opensearchserverless_access_policy.this.policy_version
}