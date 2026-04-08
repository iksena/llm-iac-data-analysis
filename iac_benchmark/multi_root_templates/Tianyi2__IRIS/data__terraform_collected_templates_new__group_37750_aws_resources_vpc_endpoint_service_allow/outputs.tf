output "id" {
  description = "The ID of the association."
  value       = aws_vpc_endpoint_service_allowed_principal.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_vpc_endpoint_service_allowed_principal.this.region
}

output "vpc_endpoint_service_id" {
  description = "The ID of the VPC endpoint service to allow permission."
  value       = aws_vpc_endpoint_service_allowed_principal.this.vpc_endpoint_service_id
}

output "principal_arn" {
  description = "The ARN of the principal to allow permissions."
  value       = aws_vpc_endpoint_service_allowed_principal.this.principal_arn
}