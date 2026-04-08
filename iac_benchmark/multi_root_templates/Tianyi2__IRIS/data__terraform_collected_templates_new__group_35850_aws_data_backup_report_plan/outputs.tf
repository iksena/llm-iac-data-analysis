output "arn" {
  description = "ARN of the backup report plan."
  value       = data.aws_backup_report_plan.this.arn
}

output "creation_time" {
  description = "Date and time that a report plan is created, in Unix format and Coordinated Universal Time (UTC)."
  value       = data.aws_backup_report_plan.this.creation_time
}

output "deployment_status" {
  description = "Deployment status of a report plan. The statuses are: CREATE_IN_PROGRESS | UPDATE_IN_PROGRESS | DELETE_IN_PROGRESS | COMPLETED."
  value       = data.aws_backup_report_plan.this.deployment_status
}

output "description" {
  description = "Description of the report plan."
  value       = data.aws_backup_report_plan.this.description
}

output "id" {
  description = "ID of the report plan."
  value       = data.aws_backup_report_plan.this.id
}

output "report_delivery_channel" {
  description = "An object that contains information about where and how to deliver your reports, specifically your Amazon S3 bucket name, S3 key prefix, and the formats of your reports."
  value       = data.aws_backup_report_plan.this.report_delivery_channel
}

output "report_setting" {
  description = "An object that identifies the report template for the report. Reports are built using a report template."
  value       = data.aws_backup_report_plan.this.report_setting
}

output "tags" {
  description = "Metadata that you can assign to help organize the report plans you create."
  value       = data.aws_backup_report_plan.this.tags
}