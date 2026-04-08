output "policy_version" {
  description = "Version of the policy"
  value       = aws_opensearchserverless_lifecycle_policy.this.policy_version
}