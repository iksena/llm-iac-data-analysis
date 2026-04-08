output "ip_address" {
  description = "IP Address of DNS node"
  sensitive   = false
  value       = var.ip_address
}

output "credentials" {
  description = "DNS node credentials"
  sensitive   = true
  value = {
    username        = local.dns_node.username
    ssh_private_key = tls_private_key.root_ssh.private_key_openssh
  }
}
