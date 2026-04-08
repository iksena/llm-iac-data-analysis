output "arn" {
  description = "Amazon Resource Name (ARN) of the schema"
  value       = aws_glue_schema.this.arn
}

output "id" {
  description = "Amazon Resource Name (ARN) of the schema"
  value       = aws_glue_schema.this.id
}

output "registry_name" {
  description = "The name of the Glue Registry"
  value       = aws_glue_schema.this.registry_name
}

output "latest_schema_version" {
  description = "The latest version of the schema associated with the returned schema definition"
  value       = aws_glue_schema.this.latest_schema_version
}

output "next_schema_version" {
  description = "The next version of the schema associated with the returned schema definition"
  value       = aws_glue_schema.this.next_schema_version
}

output "schema_checkpoint" {
  description = "The version number of the checkpoint (the last time the compatibility mode was changed)"
  value       = aws_glue_schema.this.schema_checkpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_glue_schema.this.tags_all
}