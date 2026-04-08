output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your state machine alias."
  value       = aws_sfn_alias.this.arn
}

output "creation_date" {
  description = "The date the state machine alias was created."
  value       = aws_sfn_alias.this.creation_date
}