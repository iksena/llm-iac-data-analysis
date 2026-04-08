output "ip_address" {
  description = "IP Address of VPN node"
  sensitive   = false
  value       = var.ip_address
}

output "credentials" {
  description = "VPN node credentials"
  sensitive   = true
  value = {
    username        = local.vpn_node.username
    ssh_private_key = tls_private_key.root_ssh.private_key_openssh
  }
}

output "wireguard_client_configuration" {
  description = "wireguard Client configuration"
  sensitive   = true
  value       = local.wireguard_configuration.client
}
