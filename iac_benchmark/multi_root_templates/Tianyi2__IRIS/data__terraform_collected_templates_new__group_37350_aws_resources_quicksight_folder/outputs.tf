output "arn" {
  description = "ARN of the folder"
  value       = aws_quicksight_folder.this.arn
}

output "created_time" {
  description = "The time that the folder was created"
  value       = aws_quicksight_folder.this.created_time
}

output "folder_path" {
  description = "An array of ancestor ARN strings for the folder. Empty for root-level folders"
  value       = aws_quicksight_folder.this.folder_path
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and folder ID"
  value       = aws_quicksight_folder.this.id
}

output "last_updated_time" {
  description = "The time that the folder was last updated"
  value       = aws_quicksight_folder.this.last_updated_time
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_quicksight_folder.this.tags_all
}