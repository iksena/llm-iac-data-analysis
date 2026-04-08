output "arn" {
  description = "ARN of the parameter."
  value       = data.aws_ssm_parameter.this.arn
}

output "name" {
  description = "Name of the parameter."
  value       = data.aws_ssm_parameter.this.name
}

output "type" {
  description = "Type of the parameter. Valid types are String, StringList and SecureString."
  value       = data.aws_ssm_parameter.this.type
}

output "value" {
  description = "Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type."
  value       = data.aws_ssm_parameter.this.value
  sensitive   = true
}

output "insecure_value" {
  description = "Value of the parameter. Use caution: This value is never marked as sensitive."
  value       = data.aws_ssm_parameter.this.insecure_value
}

output "version" {
  description = "Version of the parameter."
  value       = data.aws_ssm_parameter.this.version
}