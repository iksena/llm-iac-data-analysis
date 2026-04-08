output "arn" {
  description = "ARN of the studio"
  value       = aws_emr_studio.this.arn
}

output "url" {
  description = "The unique access URL of the Amazon EMR Studio"
  value       = aws_emr_studio.this.url
}

output "id" {
  description = "The ID of the EMR Studio"
  value       = aws_emr_studio.this.id
}