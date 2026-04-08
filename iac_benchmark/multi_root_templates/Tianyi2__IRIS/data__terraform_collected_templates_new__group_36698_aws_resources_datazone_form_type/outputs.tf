output "domain_identifier" {
  description = "Identifier of the domain"
  value       = aws_datazone_form_type.this.domain_identifier
}

output "name" {
  description = "Name of the form type"
  value       = aws_datazone_form_type.this.name
}

output "owning_project_identifier" {
  description = "Identifier of project that owns the form type"
  value       = aws_datazone_form_type.this.owning_project_identifier
}

output "model_smithy" {
  description = "Smithy document that indicates the model of the API"
  value       = aws_datazone_form_type.this.model[0].smithy
}

output "description" {
  description = "Description of form type"
  value       = aws_datazone_form_type.this.description
}

output "status" {
  description = "Status of form type"
  value       = aws_datazone_form_type.this.status
}

output "created_at" {
  description = "Creation time of the Form Type"
  value       = aws_datazone_form_type.this.created_at
}

output "created_by" {
  description = "Creator of the Form Type"
  value       = aws_datazone_form_type.this.created_by
}

output "origin_domain_id" {
  description = "Origin domain id of the Form Type"
  value       = aws_datazone_form_type.this.origin_domain_id
}

output "origin_project_id" {
  description = "Origin project id of the Form Type"
  value       = aws_datazone_form_type.this.origin_project_id
}


output "revision" {
  description = "Revision of the Form Type"
  value       = aws_datazone_form_type.this.revision
}