output "grant_id" {
  description = "The unique identifier for the grant."
  value       = aws_kms_grant.this.grant_id
}

output "grant_token" {
  description = "The grant token for the created grant."
  value       = aws_kms_grant.this.grant_token
  sensitive   = true
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_kms_grant.this.region
}

output "name" {
  description = "A friendly name for identifying the grant."
  value       = aws_kms_grant.this.name
}

output "key_id" {
  description = "The unique identifier for the customer master key (CMK) that the grant applies to."
  value       = aws_kms_grant.this.key_id
}

output "grantee_principal" {
  description = "The principal that is given permission to perform the operations that the grant permits."
  value       = aws_kms_grant.this.grantee_principal
}

output "operations" {
  description = "A list of operations that the grant permits."
  value       = aws_kms_grant.this.operations
}

output "retiring_principal" {
  description = "The principal that is given permission to retire the grant by using RetireGrant operation."
  value       = aws_kms_grant.this.retiring_principal
}

output "constraints" {
  description = "A structure that allows certain operations in the grant only when the desired encryption context is present."
  value       = aws_kms_grant.this.constraints
}

output "grant_creation_tokens" {
  description = "A list of grant tokens used when creating the grant."
  value       = aws_kms_grant.this.grant_creation_tokens
  sensitive   = true
}

output "retire_on_delete" {
  description = "Whether the grants will be retired upon deletion."
  value       = aws_kms_grant.this.retire_on_delete
}