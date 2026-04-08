output "arn" {
  description = "The Amazon Resource Name (ARN) of the Hours of Operation."
  value       = aws_connect_hours_of_operation.this.arn
}

output "hours_of_operation_id" {
  description = "The identifier for the hours of operation."
  value       = aws_connect_hours_of_operation.this.hours_of_operation_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Hours of Operation separated by a colon (:)."
  value       = aws_connect_hours_of_operation.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_hours_of_operation.this.tags_all
}