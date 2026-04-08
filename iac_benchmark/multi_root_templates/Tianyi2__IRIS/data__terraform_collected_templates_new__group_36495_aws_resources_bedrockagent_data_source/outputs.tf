output "data_source_id" {
  description = "Unique identifier of the data source"
  value       = aws_bedrockagent_data_source.this.data_source_id
}

output "id" {
  description = "Identifier of the data source which consists of the data source ID and the knowledge base ID"
  value       = aws_bedrockagent_data_source.this.id
}