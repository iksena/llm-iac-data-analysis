output "id" {
  description = "A comma-delimited string joining AWS account ID, folder ID, member type, and member ID."
  value       = aws_quicksight_folder_membership.this.id
}