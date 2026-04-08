# Create a admin role for accessing database
# All IAM users that wish to access the database should be granted this role
# Reference: https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_role
resource "postgresql_role" "admin_role" {
  name = "cloud_symbol_server_admin"
}

# Allow admin role to use database
# Reference: https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant#examples
# Reference: https://www.postgresql.org/docs/current/ddl-priv.html
# Reference: https://dba.stackexchange.com/questions/117109/how-to-manage-default-privileges-for-users-on-a-database-vs-schema
resource "postgresql_grant" "admin_role_allow_database_connect" {
  depends_on = [ postgresql_role.admin_role ]
  database    = var.database_name
  role        = postgresql_role.admin_role.name
  object_type = "database"
  privileges  = [ "CONNECT" ]
}

# Allow admin role to create and access objects within schema
# Reference: https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant#examples
# Reference: https://www.postgresql.org/docs/current/ddl-priv.html
# Reference: https://dba.stackexchange.com/questions/117109/how-to-manage-default-privileges-for-users-on-a-database-vs-schema
resource "postgresql_grant" "admin_role_allow_schema_usage" {
  depends_on = [ postgresql_grant.admin_role_allow_database_connect ]
  database    = var.database_name
  role        = postgresql_role.admin_role.name
  schema      = var.schema_name
  object_type = "schema"
  privileges  = [ "CREATE", "USAGE" ]
}
