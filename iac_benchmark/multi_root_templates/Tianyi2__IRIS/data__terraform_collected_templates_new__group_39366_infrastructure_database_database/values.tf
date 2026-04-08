output "database_name" {
  value = postgresql_database.db.name
}

output "schema_name" {
  value = postgresql_schema.schema.name
}
