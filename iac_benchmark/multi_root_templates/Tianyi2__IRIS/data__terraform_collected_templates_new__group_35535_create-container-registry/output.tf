output "out_acr_login_server" {
  value     = azurerm_container_registry.acr.login_server
  sensitive = true
}

output "out_acr_login_server_url" {
  value = "https://${azurerm_container_registry.acr.login_server}"
  sensitive = true
}

output "out_acr_login_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "out_acr_login_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}