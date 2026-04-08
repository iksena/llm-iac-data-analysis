output "arn" {
  description = "The CodeConnections Host ARN"
  value       = aws_codeconnections_host.this.arn
}

output "id" {
  description = "The CodeConnections Host ARN"
  value       = aws_codeconnections_host.this.arn
}


output "region" {
  description = "Region where the resource is managed"
  value       = aws_codeconnections_host.this.region
}

output "name" {
  description = "The name of the host"
  value       = aws_codeconnections_host.this.name
}

output "provider_endpoint" {
  description = "The endpoint of the infrastructure represented by the host"
  value       = aws_codeconnections_host.this.provider_endpoint
}

output "provider_type" {
  description = "The name of the external provider"
  value       = aws_codeconnections_host.this.provider_type
}

output "vpc_configuration" {
  description = "The VPC configuration provisioned for the host"
  value       = aws_codeconnections_host.this.vpc_configuration
}