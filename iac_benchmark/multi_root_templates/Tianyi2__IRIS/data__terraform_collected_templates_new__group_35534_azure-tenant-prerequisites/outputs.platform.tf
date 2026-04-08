output "out_platform_name" {
  value = azuread_application.platform.display_name
}

output "out_platform_url" {
  value = var.platform_url
}

output "out_platform_sp_client_id" {
  value = azuread_application.platform.client_id
}

output "out_platform_sp_object_id" {
  value = azuread_service_principal.platform.object_id
}

output "out_platform_sp_client_secret" {
  value     = azuread_application_password.platform_password.value
  sensitive = true
}

output "out_cosmo_api_url" {
  value = "https://${var.dns_record}.${var.dns_zone_name}/${var.kubernetes_tenant_namespace}/${var.api_version_path}"
}