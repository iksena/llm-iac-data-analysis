output "id" {
  description = "The id of the Glue User Defined Function."
  value       = aws_glue_user_defined_function.this.id
}

output "arn" {
  description = "The ARN of the Glue User Defined Function."
  value       = aws_glue_user_defined_function.this.arn
}

output "create_time" {
  description = "The time at which the function was created."
  value       = aws_glue_user_defined_function.this.create_time
}