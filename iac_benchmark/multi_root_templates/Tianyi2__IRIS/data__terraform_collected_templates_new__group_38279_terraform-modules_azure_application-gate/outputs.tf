output "application_gateway_id" {
  description = "The ID of the application gateway."
  value       = azurerm_application_gateway.app_gw.id
}

output "application_gateway_name" {
  description = "The name of the application gateway."
  value       = azurerm_application_gateway.app_gw.name
}

output "application_gateway_frontend_ip_configurations" {
  description = "The frontend IP configurations of the application gateway."
  value       = azurerm_application_gateway.app_gw.frontend_ip_configuration
}

output "application_gateway_frontend_ports" {
  description = "The frontend ports of the application gateway."
  value       = azurerm_application_gateway.app_gw.frontend_port
}

output "application_gateway_http_listeners" {
  description = "The HTTP listeners of the application gateway."
  value       = azurerm_application_gateway.app_gw.http_listener
}

output "application_gateway_backend_address_pools" {
  description = "The backend address pools of the application gateway."
  value       = azurerm_application_gateway.app_gw.backend_address_pool
}

output "application_gateway_backend_http_settings" {
  description = "The backend HTTP settings of the application gateway."
  value       = azurerm_application_gateway.app_gw.backend_http_settings
}

output "application_gateway_request_routing_rules" {
  description = "The request routing rules of the application gateway."
  value       = azurerm_application_gateway.app_gw.request_routing_rule
}

output "application_gateway_waf_configuration" {
  description = "The Web Application Firewall configuration of the application gateway."
  value       = azurerm_application_gateway.app_gw.waf_configuration
}
