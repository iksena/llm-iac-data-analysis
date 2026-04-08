output "id" {
  description = "Identifier of the service action."
  value       = aws_servicecatalog_service_action.this.id
}

output "name" {
  description = "Self-service action name."
  value       = aws_servicecatalog_service_action.this.name
}

output "description" {
  description = "Self-service action description."
  value       = aws_servicecatalog_service_action.this.description
}

output "accept_language" {
  description = "Language code."
  value       = aws_servicecatalog_service_action.this.accept_language
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_servicecatalog_service_action.this.region
}

output "definition" {
  description = "Self-service action definition configuration."
  value = {
    name        = aws_servicecatalog_service_action.this.definition[0].name
    version     = aws_servicecatalog_service_action.this.definition[0].version
    type        = aws_servicecatalog_service_action.this.definition[0].type
    assume_role = aws_servicecatalog_service_action.this.definition[0].assume_role
    parameters  = aws_servicecatalog_service_action.this.definition[0].parameters
  }
}