output "arn" {
  description = "Amazon Resource Name (ARN) of the organization conformance pack."
  value       = aws_config_organization_conformance_pack.this.arn
}

output "id" {
  description = "The name of the organization conformance pack."
  value       = aws_config_organization_conformance_pack.this.id
}