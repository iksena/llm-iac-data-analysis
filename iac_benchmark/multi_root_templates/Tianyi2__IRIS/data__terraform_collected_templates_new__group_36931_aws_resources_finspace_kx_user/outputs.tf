output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX user."
  value       = aws_finspace_kx_user.this.arn
}

output "id" {
  description = "A comma-delimited string joining environment ID and user name."
  value       = aws_finspace_kx_user.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_finspace_kx_user.this.tags_all
}