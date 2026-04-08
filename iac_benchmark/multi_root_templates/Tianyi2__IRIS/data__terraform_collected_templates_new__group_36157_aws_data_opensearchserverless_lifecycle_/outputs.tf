output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.region
}

output "name" {
  description = "Name of the policy"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.name
}

output "type" {
  description = "Type of lifecycle policy"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.type
}

output "created_date" {
  description = "The date the lifecycle policy was created"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.created_date
}

output "description" {
  description = "Description of the policy. Typically used to store information about the permissions defined in the policy"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.description
}

output "last_modified_date" {
  description = "The date the lifecycle policy was last modified"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.last_modified_date
}

output "policy" {
  description = "JSON policy document to use as the content for the new policy"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.policy
}

output "policy_version" {
  description = "Version of the policy"
  value       = data.aws_opensearchserverless_lifecycle_policy.this.policy_version
}