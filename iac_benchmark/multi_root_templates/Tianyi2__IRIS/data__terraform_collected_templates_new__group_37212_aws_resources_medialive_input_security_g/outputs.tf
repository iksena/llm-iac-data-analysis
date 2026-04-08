output "id" {
  description = "InputSecurityGroup Id."
  value       = aws_medialive_input_security_group.this.id
}

output "arn" {
  description = "ARN of the InputSecurityGroup."
  value       = aws_medialive_input_security_group.this.arn
}

output "inputs" {
  description = "The list of inputs currently using this InputSecurityGroup."
  value       = aws_medialive_input_security_group.this.inputs
}