output "created_by" {
  description = "Creator of the project"
  value       = aws_datazone_project.this.created_by
}

output "domain_id" {
  description = "Id of the project's DataZone domain"
  value       = var.domain_identifier
}

output "id" {
  description = "Id of the project"
  value       = aws_datazone_project.this.id
}

output "name" {
  description = "Name of the project"
  value       = aws_datazone_project.this.name
}

output "created_at" {
  description = "Timestamp of when the project was made"
  value       = aws_datazone_project.this.created_at
}

output "description" {
  description = "Description of the project"
  value       = aws_datazone_project.this.description
}

output "failure_reasons" {
  description = "List of error messages if operation cannot be completed"
  value       = aws_datazone_project.this.failure_reasons
}

output "glossary_terms" {
  description = "Business glossary terms that can be used in the project"
  value       = aws_datazone_project.this.glossary_terms
}

output "last_updated_at" {
  description = "Timestamp of when the project was last updated"
  value       = aws_datazone_project.this.last_updated_at
}

output "project_status" {
  description = "Enum that conveys state of project. Can be ACTIVE, DELETING, or DELETE_FAILED"
  value       = aws_datazone_project.this.project_status
}