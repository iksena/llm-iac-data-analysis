output "namespaces" {
  description = "Identifies the namespaces of the entities referenced by this schema."
  value       = aws_verifiedpermissions_schema.this.namespaces
}

output "region" {
  description = "The AWS region where the resource is created."
  value       = aws_verifiedpermissions_schema.this.region
}

output "policy_store_id" {
  description = "The ID of the Policy Store."
  value       = aws_verifiedpermissions_schema.this.policy_store_id
}

output "definition" {
  description = "The definition of the schema."
  value       = aws_verifiedpermissions_schema.this.definition
}