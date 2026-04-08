output "all_allowed" {
  description = "True if all of the simulation results have decision 'allowed', or false otherwise."
  value       = data.aws_iam_principal_policy_simulation.this.all_allowed
}

output "results" {
  description = "A set of result objects, one for each of the simulated requests."
  value       = data.aws_iam_principal_policy_simulation.this.results
}

output "action_names" {
  description = "The set of IAM action names that were simulated."
  value       = data.aws_iam_principal_policy_simulation.this.action_names
}

output "policy_source_arn" {
  description = "The ARN of the IAM user, group, or role whose policies were included in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.policy_source_arn
}

output "caller_arn" {
  description = "The ARN of the user that appeared as the 'caller' of the simulated requests."
  value       = data.aws_iam_principal_policy_simulation.this.caller_arn
}

output "context" {
  description = "The context entries that were used in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.context
}

output "additional_policies_json" {
  description = "The additional principal policy documents that were included in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.additional_policies_json
}

output "permissions_boundary_policies_json" {
  description = "The permissions boundary policy documents that were included in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.permissions_boundary_policies_json
}

output "resource_arns" {
  description = "The ARNs of resources that were included in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.resource_arns
}

output "resource_handling_option" {
  description = "The special simulation type that was used."
  value       = data.aws_iam_principal_policy_simulation.this.resource_handling_option
}

output "resource_owner_account_id" {
  description = "The AWS account ID that was used for resource ARNs."
  value       = data.aws_iam_principal_policy_simulation.this.resource_owner_account_id
}

output "resource_policy_json" {
  description = "The resource-level policy document that was used in the simulation."
  value       = data.aws_iam_principal_policy_simulation.this.resource_policy_json
}