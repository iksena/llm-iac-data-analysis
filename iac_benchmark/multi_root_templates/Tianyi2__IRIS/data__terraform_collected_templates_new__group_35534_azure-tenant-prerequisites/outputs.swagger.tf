output "out_swagger_name" {
  value = azuread_application.swagger.display_name
}

output "out_swagger_sp_client_id" {
  value = azuread_application.swagger.client_id
}