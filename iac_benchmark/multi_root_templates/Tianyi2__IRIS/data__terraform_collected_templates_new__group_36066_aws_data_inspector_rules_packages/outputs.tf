output "id" {
  description = "AWS Region"
  value       = data.aws_inspector_rules_packages.this.id
}

output "arns" {
  description = "List of the Amazon Inspector Classic Rules Packages arns available in the AWS region"
  value       = data.aws_inspector_rules_packages.this.arns
}