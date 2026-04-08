output "arns" {
  description = "A list that contains the Amazon Resource Names (ARNs) of the retrieved parameters."
  value       = data.aws_ssm_parameters_by_path.this.arns
}

output "names" {
  description = "A list that contains the names of the retrieved parameters."
  value       = data.aws_ssm_parameters_by_path.this.names
}

output "types" {
  description = "A list that contains the types (String, StringList, or SecureString) of retrieved parameters."
  value       = data.aws_ssm_parameters_by_path.this.types
}

output "values" {
  description = "A list that contains the retrieved parameter values. This value is always marked as sensitive in the Terraform plan output, regardless of whether any retrieved parameters are of SecureString type."
  value       = data.aws_ssm_parameters_by_path.this.values
  sensitive   = true
}