output "id" {
  description = "Name of the Vocabulary"
  value       = aws_transcribe_vocabulary.this.id
}

output "arn" {
  description = "ARN of the Vocabulary"
  value       = aws_transcribe_vocabulary.this.arn
}

output "download_uri" {
  description = "Generated download URI"
  value       = aws_transcribe_vocabulary.this.download_uri
}