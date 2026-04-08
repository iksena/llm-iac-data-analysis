output "out_babylon_sp_client_id" {
  value = var.create_babylon ? azuread_application.babylon.0.client_id : null
}

output "out_babylon_sp_object_id" {
  value = var.create_babylon ? azuread_service_principal.babylon.0.object_id : null
}

output "out_babylon_sp_client_secret" {
  value     = var.create_babylon ? azuread_application_password.babylon_password.0.value : null
  sensitive = true
}

output "out_babylon_sp_name" {
  value = var.create_babylon ? azuread_service_principal.babylon.0.display_name : null
}