output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_folder.this.region
}

output "id" {
  description = "The ID of the QuickSight folder."
  value       = aws_quicksight_folder.this.folder_id
}

output "arn" {
  description = "The ARN of the QuickSight folder."
  value       = aws_quicksight_folder.this.arn
}

output "name" {
  description = "The name of the QuickSight folder."
  value       = aws_quicksight_folder.this.folder_id
}

output "display_name" {
  description = "The display name of the QuickSight folder."
  value       = aws_quicksight_folder.this.name
}

output "type" {
  description = "The type of the QuickSight folder."
  value       = aws_quicksight_folder.this.folder_type
}

output "hierarchy" {
  description = "The hierarchy of the QuickSight folder."
  value = {
    path          = aws_quicksight_folder.this.folder_path
    parent_folder = aws_quicksight_folder.this.parent_folder_arn
  }
}

output "permissions" {
  description = "A list of resource permissions on the QuickSight folder."
  value       = aws_quicksight_folder.this.permissions
}

output "created_at" {
  description = "The time that the QuickSight folder was created."
  value       = aws_quicksight_folder.this.created_time
}

output "updated_at" {
  description = "The time that the QuickSight folder was last updated."
  value       = aws_quicksight_folder.this.last_updated_time
}

output "assets" {
  description = <<EOF
  A configuration for assets of this QuickSight folder.
    `analyses` - A list of the IDs of the analysis assets of this QuickSight folder.
    `dashboards` - A list of the IDs of the dashboard assets of this QuickSight folder.
    `datasets` - A list of the IDs of the dataset assets of this QuickSight folder.
  EOF
  value = {
    analyses = [
      for analysis in aws_quicksight_folder_membership.analysis :
      analysis.member_id
    ]
    dashboards = [
      for dashboard in aws_quicksight_folder_membership.dashboard :
      dashboard.member_id
    ]
    datasets = [
      for dataset in aws_quicksight_folder_membership.dataset :
      dataset.member_id
    ]
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

# output "debug" {
#   value = {
#     for k, v in aws_quicksight_folder.this :
#     k => v
#     if !contains(["arn", "folder_id", "name", "folder_type", "parent_folder_arn", "created_time", "last_updated_time", "tags", "tags_all", "timeouts", "permissions", "id", "folder_path", "aws_account_id", "region"], k)
#   }
# }
