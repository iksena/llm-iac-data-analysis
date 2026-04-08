output "region" {
  description = "Region where this resource is managed"
  value       = aws_inspector2_organization_configuration.this.region
}

output "auto_enable_ec2" {
  description = "Whether Amazon EC2 scans are automatically enabled for new members"
  value       = aws_inspector2_organization_configuration.this.auto_enable[0].ec2
}

output "auto_enable_ecr" {
  description = "Whether Amazon ECR scans are automatically enabled for new members"
  value       = aws_inspector2_organization_configuration.this.auto_enable[0].ecr
}

output "auto_enable_code_repository" {
  description = "Whether code repository scans are automatically enabled for new members"
  value       = aws_inspector2_organization_configuration.this.auto_enable[0].code_repository
}

output "auto_enable_lambda" {
  description = "Whether Lambda Function scans are automatically enabled for new members"
  value       = aws_inspector2_organization_configuration.this.auto_enable[0].lambda
}

output "auto_enable_lambda_code" {
  description = "Whether AWS Lambda code scans are automatically enabled for new members"
  value       = aws_inspector2_organization_configuration.this.auto_enable[0].lambda_code
}

output "max_account_limit_reached" {
  description = "Whether your configuration reached the max account limit"
  value       = aws_inspector2_organization_configuration.this.max_account_limit_reached
}