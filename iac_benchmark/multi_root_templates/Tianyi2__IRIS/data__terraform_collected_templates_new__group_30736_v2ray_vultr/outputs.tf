# https://developer.hashicorp.com/terraform/language/values/outputs

output "server_ip" {
  description = "The IPv4 address for accessing the V2Ray server."
  value       = vultr_instance.server.main_ip
}

output "server_url" {
  description = "The URL for accessing the V2Ray server."
  value       = local.subdomain
}

output "vpn_link" {
  description = "The VPN link for connecting to V2Ray server."
  value       = format("vmess://%s", base64encode(data.template_file.client_config.rendered))
}
