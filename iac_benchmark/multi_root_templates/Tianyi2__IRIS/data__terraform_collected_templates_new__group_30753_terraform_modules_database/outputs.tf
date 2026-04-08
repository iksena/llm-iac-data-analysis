output "server_id" {
  description = "ID of the SQL server"
  value       = azurerm_mssql_server.main.id
}

output "server_name" {
  description = "Name of the SQL server"
  value       = azurerm_mssql_server.main.name
}

output "server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "database_name" {
  description = "Name of the application database"
  value       = azurerm_mssql_database.main.name
}

output "admin_username" {
  description = "Administrator username for the SQL server"
  value       = azurerm_mssql_server.main.administrator_login
}

output "admin_password" {
  description = "Administrator password for the SQL server"
  value       = random_password.sql_admin.result
  sensitive   = true
}

output "connection_string" {
  description = "SQL Server connection string"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${azurerm_mssql_server.main.administrator_login};Password=${random_password.sql_admin.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}
