output "waf_policy_id" {
  value       = azurerm_web_application_firewall_policy.waf_policy.id
  description = "The ID of the Web Application Firewall Policy."
}

output "waf_policy_name" {
  value       = azurerm_web_application_firewall_policy.waf_policy.name
  description = "The name of the Web Application Firewall Policy."
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.workspace.id
  description = "The ID of the Log Analytics Workspace."
}

output "log_analytics_workspace_name" {
  value       = azurerm_log_analytics_workspace.workspace.name
  description = "The name of the Log Analytics Workspace."
}

# output "diagnostic_setting_id" {
#   value       = azurerm_monitor_diagnostic_setting.waf_diagnostics.id
#   description = "The ID of the Diagnostic Setting."
# }

# output "diagnostic_setting_name" {
#   value       = azurerm_monitor_diagnostic_setting.waf_diagnostics.name
#   description = "The name of the Diagnostic Setting."
# }
