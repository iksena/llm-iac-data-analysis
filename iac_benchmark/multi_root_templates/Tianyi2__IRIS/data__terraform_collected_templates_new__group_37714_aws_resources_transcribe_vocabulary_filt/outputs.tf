output "id" {
  description = "VocabularyFilter name."
  value       = aws_transcribe_vocabulary_filter.this.id
}

output "arn" {
  description = "ARN of the VocabularyFilter."
  value       = aws_transcribe_vocabulary_filter.this.arn
}

output "download_uri" {
  description = "Generated download URI."
  value       = aws_transcribe_vocabulary_filter.this.download_uri
}