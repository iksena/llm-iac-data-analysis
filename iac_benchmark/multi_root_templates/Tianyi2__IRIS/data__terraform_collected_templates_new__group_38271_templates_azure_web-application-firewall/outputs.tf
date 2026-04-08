output "waf_policy_id" {
  value       = module.waf.waf_policy_id
  description = "The ID of the Web Application Firewall Policy."
}

output "waf_policy_name" {
  value       = module.waf.waf_policy_name
  description = "The name of the Web Application Firewall Policy."
}

output "log_analytics_workspace_id" {
  value       = module.waf.log_analytics_workspace_id
  description = "The ID of the Log Analytics Workspace."
}

output "log_analytics_workspace_name" {
  value       = module.waf.log_analytics_workspace_name
  description = "The name of the Log Analytics Workspace."
}