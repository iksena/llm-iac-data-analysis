output "arn" {
  description = "ARN of the Ingestion"
  value       = aws_quicksight_ingestion.this.arn
}

output "id" {
  description = "A comma-delimited string joining AWS account ID, data set ID, and ingestion ID"
  value       = aws_quicksight_ingestion.this.id
}

output "ingestion_status" {
  description = "Ingestion status"
  value       = aws_quicksight_ingestion.this.ingestion_status
}