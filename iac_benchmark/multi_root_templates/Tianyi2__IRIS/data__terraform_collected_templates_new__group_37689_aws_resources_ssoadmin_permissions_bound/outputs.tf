output "id" {
  description = "Permission Set Amazon Resource Name (ARN) and SSO Instance ARN, separated by a comma (`,`)."
  value       = aws_ssoadmin_permissions_boundary_attachment.this.id
}

output "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  value       = aws_ssoadmin_permissions_boundary_attachment.this.instance_arn
}

output "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  value       = aws_ssoadmin_permissions_boundary_attachment.this.permission_set_arn
}

output "permissions_boundary" {
  description = "The permissions boundary policy configuration."
  value       = aws_ssoadmin_permissions_boundary_attachment.this.permissions_boundary
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssoadmin_permissions_boundary_attachment.this.region
}