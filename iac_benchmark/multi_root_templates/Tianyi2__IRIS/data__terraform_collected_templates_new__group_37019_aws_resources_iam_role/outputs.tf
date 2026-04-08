output "arn" {
  description = "Amazon Resource Name (ARN) specifying the role"
  value       = aws_iam_role.this.arn
}

output "create_date" {
  description = "Creation date of the IAM role"
  value       = aws_iam_role.this.create_date
}

output "id" {
  description = "Name of the role"
  value       = aws_iam_role.this.id
}

output "name" {
  description = "Name of the role"
  value       = aws_iam_role.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iam_role.this.tags_all
}

output "unique_id" {
  description = "Stable and unique string identifying the role"
  value       = aws_iam_role.this.unique_id
}