output "arn" {
  description = "ARN of the Glue Connection."
  value       = data.aws_glue_connection.this.arn
}

output "catalog_id" {
  description = "Catalog ID of the Glue Connection."
  value       = data.aws_glue_connection.this.catalog_id
}

output "athena_properties" {
  description = "A map of connection properties specific to the Athena compute environment."
  value       = data.aws_glue_connection.this.athena_properties
}

output "connection_properties" {
  description = "A map of connection properties."
  value       = data.aws_glue_connection.this.connection_properties
}

output "connection_type" {
  description = "Type of Glue Connection."
  value       = data.aws_glue_connection.this.connection_type
}

output "description" {
  description = "Description of the connection."
  value       = data.aws_glue_connection.this.description
}

output "match_criteria" {
  description = "A list of criteria that can be used in selecting this connection."
  value       = data.aws_glue_connection.this.match_criteria
}

output "name" {
  description = "Name of the Glue Connection."
  value       = data.aws_glue_connection.this.name
}

output "physical_connection_requirements" {
  description = "A map of physical connection requirements, such as VPC and SecurityGroup."
  value       = data.aws_glue_connection.this.physical_connection_requirements
}

output "tags" {
  description = "Tags assigned to the resource."
  value       = data.aws_glue_connection.this.tags
}