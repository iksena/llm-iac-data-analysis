output "created_at" {
  description = "Unix epoch timestamp in seconds for when the Guardrail was created"
  value       = aws_bedrock_guardrail.this.created_at
}

output "guardrail_arn" {
  description = "ARN of the Guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_arn
}

output "guardrail_id" {
  description = "ID of the Guardrail"
  value       = aws_bedrock_guardrail.this.guardrail_id
}

output "status" {
  description = "Status of the Bedrock Guardrail"
  value       = aws_bedrock_guardrail.this.status
}

output "version" {
  description = "Version of the Guardrail"
  value       = aws_bedrock_guardrail.this.version
}