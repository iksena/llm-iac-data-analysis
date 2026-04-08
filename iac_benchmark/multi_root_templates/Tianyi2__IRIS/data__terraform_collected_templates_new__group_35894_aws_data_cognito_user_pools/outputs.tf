output "ids" {
  description = "Set of cognito user pool ids."
  value       = data.aws_cognito_user_pools.this.ids
}

output "arns" {
  description = "Set of cognito user pool Amazon Resource Names (ARNs)."
  value       = data.aws_cognito_user_pools.this.arns
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_cognito_user_pools.this.region
}

output "name" {
  description = "Name of the cognito user pools."
  value       = data.aws_cognito_user_pools.this.name
}