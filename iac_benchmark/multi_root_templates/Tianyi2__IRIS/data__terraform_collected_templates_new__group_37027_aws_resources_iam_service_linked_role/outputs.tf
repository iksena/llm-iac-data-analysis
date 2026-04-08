output "id" {
  description = "The Amazon Resource Name (ARN) of the role."
  value       = aws_iam_service_linked_role.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_service_linked_role.this.arn
}

output "create_date" {
  description = "The creation date of the IAM role."
  value       = aws_iam_service_linked_role.this.create_date
}

output "name" {
  description = "The name of the role."
  value       = aws_iam_service_linked_role.this.name
}

output "path" {
  description = "The path of the role."
  value       = aws_iam_service_linked_role.this.path
}

output "unique_id" {
  description = "The stable and unique string identifying the role."
  value       = aws_iam_service_linked_role.this.unique_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iam_service_linked_role.this.tags_all
}