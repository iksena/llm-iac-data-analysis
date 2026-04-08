# https://developer.hashicorp.com/terraform/language/values/outputs

output "server_ip" {
  description = "The IPv4 address for accessing the X-UI server."
  value       = aws_instance.vpn.public_ip
}

output "panel_url" {
  description = "The URL for accessing the X-UI panel."
  value       = "https://${local.subdomain}"
}

output "panel_username" {
  description = "The username for accessing the X-UI panel."
  value       = local.panel_username
}

output "panel_password" {
  description = "The password for accessing the X-UI panel."
  value       = local.panel_password
  sensitive   = true
}
