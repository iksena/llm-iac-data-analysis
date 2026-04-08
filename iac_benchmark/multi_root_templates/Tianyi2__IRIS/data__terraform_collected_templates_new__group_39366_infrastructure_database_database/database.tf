# Create database within database instance
resource "postgresql_database" "db" {
  name              = "cloud_symbol_server"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}

# Create a schema
# All tables and other database objects will be created within this schema
# Reference: https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_schema
resource "postgresql_schema" "schema" {
  depends_on = [ postgresql_database.db ]
  name = "cloud_symbol_server"
  database = postgresql_database.db.name
}
