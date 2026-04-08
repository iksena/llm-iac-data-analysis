output "arn" {
  description = "Amazon Resource Name (ARN) of the refresh schedule."
  value       = aws_quicksight_refresh_schedule.this.arn
}

output "id" {
  description = "A comma-delimited string joining AWS account ID, data set ID & refresh schedule ID."
  value       = aws_quicksight_refresh_schedule.this.id
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = aws_quicksight_refresh_schedule.this.aws_account_id
}

output "data_set_id" {
  description = "The ID of the dataset."
  value       = aws_quicksight_refresh_schedule.this.data_set_id
}

output "schedule_id" {
  description = "The ID of the refresh schedule."
  value       = aws_quicksight_refresh_schedule.this.schedule_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_quicksight_refresh_schedule.this.region
}

output "schedule" {
  description = "The refresh schedule configuration."
  value       = aws_quicksight_refresh_schedule.this.schedule
}