output "out_restish_name" {
  value = var.create_restish ? azuread_application.restish[0].display_name : null
}

output "out_restish_sp_client_id" {
  value = var.create_restish ? azuread_application.restish[0].client_id : null
}

output "out_restish_sp_client_secret" {
  value     = var.create_restish ? azuread_application_password.restish_password[0].value : null
  sensitive = true
}