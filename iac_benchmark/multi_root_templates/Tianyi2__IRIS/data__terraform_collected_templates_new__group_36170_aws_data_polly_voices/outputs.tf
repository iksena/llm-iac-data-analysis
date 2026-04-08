output "id" {
  description = "AWS account ID."
  value       = data.aws_polly_voices.this.id
}

output "voices" {
  description = "List of voices with their properties."
  value       = data.aws_polly_voices.this.voices
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_polly_voices.this.region
}

output "engine" {
  description = "Engine used by Amazon Polly when processing input text for speech synthesis."
  value       = data.aws_polly_voices.this.engine
}

output "include_additional_language_codes" {
  description = "Whether to return any bilingual voices that use the specified language as an additional language."
  value       = data.aws_polly_voices.this.include_additional_language_codes
}

output "language_code" {
  description = "Language identification tag for filtering the list of voices returned."
  value       = data.aws_polly_voices.this.language_code
}