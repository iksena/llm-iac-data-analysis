output "id" {
  description = "Id of the glossary term"
  value       = aws_datazone_glossary_term.this.id
}

output "created_at" {
  description = "Time of glossary term creation"
  value       = aws_datazone_glossary_term.this.created_at
}

output "created_by" {
  description = "Creator of glossary term"
  value       = aws_datazone_glossary_term.this.created_by
}

output "domain_identifier" {
  description = "Identifier of domain"
  value       = aws_datazone_glossary_term.this.domain_identifier
}

output "glossary_identifier" {
  description = "Identifier of glossary"
  value       = aws_datazone_glossary_term.this.glossary_identifier
}

output "name" {
  description = "Name of glossary term"
  value       = aws_datazone_glossary_term.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_datazone_glossary_term.this.region
}

output "long_description" {
  description = "Long description of entry"
  value       = aws_datazone_glossary_term.this.long_description
}

output "short_description" {
  description = "Short description of entry"
  value       = aws_datazone_glossary_term.this.short_description
}

output "status" {
  description = "Status of glossary term (ENABLED or DISABLED)"
  value       = aws_datazone_glossary_term.this.status
}

output "term_relations" {
  description = "Object classifying the term relations"
  value       = aws_datazone_glossary_term.this.term_relations
}