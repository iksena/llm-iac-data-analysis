output "id" {
  description = "LanguageModel name"
  value       = aws_transcribe_language_model.this.id
}

output "arn" {
  description = "ARN of the LanguageModel"
  value       = aws_transcribe_language_model.this.arn
}

output "model_name" {
  description = "The model name"
  value       = aws_transcribe_language_model.this.model_name
}

output "base_model_name" {
  description = "Name of reference base model"
  value       = aws_transcribe_language_model.this.base_model_name
}

output "language_code" {
  description = "The language code selected for the language model"
  value       = aws_transcribe_language_model.this.language_code
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_transcribe_language_model.this.region
}

output "tags" {
  description = "A map of tags assigned to the LanguageModel"
  value       = aws_transcribe_language_model.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_transcribe_language_model.this.tags_all
}