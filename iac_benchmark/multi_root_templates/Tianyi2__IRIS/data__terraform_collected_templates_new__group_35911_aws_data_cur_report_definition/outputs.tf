output "report_name" {
  description = "Name of the report definition."
  value       = data.aws_cur_report_definition.this.report_name
}

output "time_unit" {
  description = "Frequency on which report data are measured and displayed."
  value       = data.aws_cur_report_definition.this.time_unit
}

output "format" {
  description = "Preferred compression format for report."
  value       = data.aws_cur_report_definition.this.format
}

output "compression" {
  description = "Preferred format for report."
  value       = data.aws_cur_report_definition.this.compression
}

output "additional_schema_elements" {
  description = "A list of schema elements."
  value       = data.aws_cur_report_definition.this.additional_schema_elements
}

output "s3_bucket" {
  description = "Name of customer S3 bucket."
  value       = data.aws_cur_report_definition.this.s3_bucket
}

output "s3_prefix" {
  description = "Preferred report path prefix."
  value       = data.aws_cur_report_definition.this.s3_prefix
}

output "s3_region" {
  description = "Region of customer S3 bucket."
  value       = data.aws_cur_report_definition.this.s3_region
}

output "additional_artifacts" {
  description = "A list of additional artifacts."
  value       = data.aws_cur_report_definition.this.additional_artifacts
}

output "refresh_closed_reports" {
  description = "If true reports are updated after they have been finalized."
  value       = data.aws_cur_report_definition.this.refresh_closed_reports
}

output "report_versioning" {
  description = "Overwrite the previous version of each report or to deliver the report in addition to the previous versions."
  value       = data.aws_cur_report_definition.this.report_versioning
}

output "tags" {
  description = "Map of key-value pairs assigned to the resource."
  value       = data.aws_cur_report_definition.this.tags
}