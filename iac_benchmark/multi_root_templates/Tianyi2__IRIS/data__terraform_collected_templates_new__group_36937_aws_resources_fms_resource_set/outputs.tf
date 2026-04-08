output "arn" {
  description = "ARN of the Resource Set."
  value       = aws_fms_resource_set.this.arn
}

output "id" {
  description = "Unique identifier for the resource set. It's returned in the responses to create and list commands. You provide it to operations like update and delete."
  value       = aws_fms_resource_set.this.id
}