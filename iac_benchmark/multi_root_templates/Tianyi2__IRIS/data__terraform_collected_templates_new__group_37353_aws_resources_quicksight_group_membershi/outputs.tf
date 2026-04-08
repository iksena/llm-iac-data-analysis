output "id" {
  description = "A unique identifier for the resource."
  value       = aws_quicksight_group_membership.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the group membership."
  value       = aws_quicksight_group_membership.this.arn
}