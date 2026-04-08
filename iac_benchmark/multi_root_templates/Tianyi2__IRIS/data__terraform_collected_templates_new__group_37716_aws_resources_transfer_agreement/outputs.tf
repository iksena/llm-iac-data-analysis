output "agreement_id" {
  description = "The unique identifier for the AS2 agreement"
  value       = aws_transfer_agreement.this.agreement_id
}

output "arn" {
  description = "The ARN of the agreement"
  value       = aws_transfer_agreement.this.arn
}

output "status" {
  description = "The status of the agreement which is either ACTIVE or INACTIVE"
  value       = aws_transfer_agreement.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_transfer_agreement.this.tags_all
}