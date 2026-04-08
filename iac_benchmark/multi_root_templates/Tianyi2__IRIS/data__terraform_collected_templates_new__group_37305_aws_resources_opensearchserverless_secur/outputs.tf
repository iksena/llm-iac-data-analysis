output "name" {
  description = "Name of the policy"
  value       = aws_opensearchserverless_security_policy.this.name
}

output "policy" {
  description = "JSON policy document to use as the content for the new policy"
  value       = aws_opensearchserverless_security_policy.this.policy
}

output "type" {
  description = "Type of security policy"
  value       = aws_opensearchserverless_security_policy.this.type
}

output "description" {
  description = "Description of the policy"
  value       = aws_opensearchserverless_security_policy.this.description
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_opensearchserverless_security_policy.this.region
}

output "policy_version" {
  description = "Version of the policy"
  value       = aws_opensearchserverless_security_policy.this.policy_version
}