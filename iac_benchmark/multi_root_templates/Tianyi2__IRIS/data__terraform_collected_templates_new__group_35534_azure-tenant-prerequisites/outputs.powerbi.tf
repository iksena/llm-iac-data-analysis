output "out_powerbi_name" {
  value = var.create_powerbi ? azuread_application.powerbi.0.display_name : null
}

output "out_powerbi_sp_client_id" {
  value = var.create_powerbi ? azuread_application.powerbi.0.client_id : null
}

output "out_powerbi_sp_client_secret" {
  value     = var.create_powerbi ? azuread_application_password.powerbi_password.0.value : null
  sensitive = true
}