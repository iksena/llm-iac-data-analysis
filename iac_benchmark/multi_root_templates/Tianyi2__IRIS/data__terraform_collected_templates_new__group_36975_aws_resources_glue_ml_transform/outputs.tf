output "arn" {
  description = "Amazon Resource Name (ARN) of Glue ML Transform."
  value       = aws_glue_ml_transform.this.arn
}

output "id" {
  description = "Glue ML Transform ID."
  value       = aws_glue_ml_transform.this.id
}

output "label_count" {
  description = "The number of labels available for this transform."
  value       = aws_glue_ml_transform.this.label_count
}

output "schema" {
  description = "The object that represents the schema that this transform accepts."
  value       = aws_glue_ml_transform.this.schema
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_glue_ml_transform.this.tags_all
}