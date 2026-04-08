output "value" {
  description = "Value from Cloudformation export identified by the export name found from list-exports"
  value       = data.aws_cloudformation_export.this.value
}

output "exporting_stack_id" {
  description = "ARN of stack that contains the exported output name and value"
  value       = data.aws_cloudformation_export.this.exporting_stack_id
}

output "name" {
  description = "Name of the export as it appears in the console or from list-exports"
  value       = data.aws_cloudformation_export.this.name
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_cloudformation_export.this.region
}