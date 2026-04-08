output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_secretsmanager_secret_rotation.this.region
}

output "secret_id" {
  description = "The secret containing the version that was retrieved."
  value       = data.aws_secretsmanager_secret_rotation.this.secret_id
}

output "rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for this secret."
  value       = data.aws_secretsmanager_secret_rotation.this.rotation_enabled
}

output "rotation_lambda_arn" {
  description = "Amazon Resource Name (ARN) of the lambda function used for rotation."
  value       = data.aws_secretsmanager_secret_rotation.this.rotation_lambda_arn
}

output "rotation_rules" {
  description = "Configuration block for rotation rules."
  value       = data.aws_secretsmanager_secret_rotation.this.rotation_rules
}