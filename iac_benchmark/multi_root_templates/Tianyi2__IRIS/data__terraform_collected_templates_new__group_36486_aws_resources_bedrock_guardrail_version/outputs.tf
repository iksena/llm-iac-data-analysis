output "guardrail_arn" {
  description = "Guardrail ARN."
  value       = aws_bedrock_guardrail_version.this.guardrail_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_bedrock_guardrail_version.this.region
}

output "description" {
  description = "Description of the Guardrail version."
  value       = aws_bedrock_guardrail_version.this.description
}

output "skip_destroy" {
  description = "Whether to retain the old version of a previously deployed Guardrail."
  value       = aws_bedrock_guardrail_version.this.skip_destroy
}

output "version" {
  description = "Guardrail version."
  value       = aws_bedrock_guardrail_version.this.version
}