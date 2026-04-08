output "id" {
  description = "Name of the MedicalVocabulary."
  value       = aws_transcribe_medical_vocabulary.this.id
}

output "arn" {
  description = "ARN of the MedicalVocabulary."
  value       = aws_transcribe_medical_vocabulary.this.arn
}

output "download_uri" {
  description = "Generated download URI."
  value       = aws_transcribe_medical_vocabulary.this.download_uri
}

output "vocabulary_name" {
  description = "The name of the Medical Vocabulary."
  value       = aws_transcribe_medical_vocabulary.this.vocabulary_name
}

output "language_code" {
  description = "The language code you selected for your medical vocabulary."
  value       = aws_transcribe_medical_vocabulary.this.language_code
}

output "vocabulary_file_uri" {
  description = "The Amazon S3 location (URI) of the text file that contains your custom medical vocabulary."
  value       = aws_transcribe_medical_vocabulary.this.vocabulary_file_uri
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_transcribe_medical_vocabulary.this.region
}

output "tags" {
  description = "A map of tags assigned to the MedicalVocabulary."
  value       = aws_transcribe_medical_vocabulary.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_transcribe_medical_vocabulary.this.tags_all
}