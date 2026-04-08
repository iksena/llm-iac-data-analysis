output "id" {
  description = "The ID or Amazon Resource Name (ARN) of the service network or service for which the policy is created."
  value       = aws_vpclattice_auth_policy.this.id
}

output "policy" {
  description = "The auth policy. The policy string in JSON must not contain newlines or blank lines."
  value       = aws_vpclattice_auth_policy.this.policy
}

output "state" {
  description = "The state of the auth policy. The auth policy is only active when the auth type is set to AWS_IAM. If you provide a policy, then authentication and authorization decisions are made based on this policy and the client's IAM policy. If the Auth type is NONE, then, any auth policy you provide will remain inactive."
  value       = aws_vpclattice_auth_policy.this.state
}