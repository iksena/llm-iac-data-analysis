output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Workforce."
  value       = aws_sagemaker_workforce.this.arn
}

output "id" {
  description = "The name of the Workforce."
  value       = aws_sagemaker_workforce.this.id
}

output "subdomain" {
  description = "The subdomain for your OIDC Identity Provider."
  value       = aws_sagemaker_workforce.this.subdomain
}

output "workforce_vpc_config_vpc_endpoint_id" {
  description = "The IDs for the VPC service endpoints of your VPC workforce."
  value       = try(aws_sagemaker_workforce.this.workforce_vpc_config[0].vpc_endpoint_id, null)
}