output "arn" {
  description = "ARN of the Document Classifier version"
  value       = aws_comprehend_document_classifier.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_comprehend_document_classifier.this.tags_all
}

output "output_s3_uri" {
  description = "Full path for the output documents"
  value       = try(aws_comprehend_document_classifier.this.output_data_config[0].output_s3_uri, null)
}