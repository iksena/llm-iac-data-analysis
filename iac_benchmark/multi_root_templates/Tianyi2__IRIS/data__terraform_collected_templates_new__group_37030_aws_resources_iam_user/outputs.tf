output "arn" {
  description = "The ARN assigned by AWS for this user"
  value       = aws_iam_user.this.arn
}

output "id" {
  description = "The user's name"
  value       = aws_iam_user.this.id
}

output "name" {
  description = "The user's name"
  value       = aws_iam_user.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iam_user.this.tags_all
}

output "unique_id" {
  description = "The unique ID assigned by AWS"
  value       = aws_iam_user.this.unique_id
}